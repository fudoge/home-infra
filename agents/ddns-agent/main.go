package main

import (
	"context"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"

	"github.com/cloudflare/cloudflare-go/v6"
	"github.com/cloudflare/cloudflare-go/v6/dns"
	"github.com/cloudflare/cloudflare-go/v6/option"
)

func main() {
	// Get IP..
	ip := getIP()
	name := os.Getenv("DOMAIN_NAME")
	zoneID := os.Getenv("ZONE_ID")

	client := cloudflare.NewClient(
		option.WithAPIToken(os.Getenv("CF_API_TOKEN")),
	)
	page, err := client.DNS.Records.List(context.TODO(), dns.RecordListParams{
		ZoneID: cloudflare.F(zoneID),
	})
	if err != nil {
		panic(err.Error())
	}

	res := page.Result
	for i := range res {
		if res[i].Name == name {
			if res[i].Content == ip {
				fmt.Println("DDNS record is up to date.")
				return
			} else {
				fmt.Printf("Updating DDNS record: A %v -> %v\n", res[i].Content, ip)
				updateRecord(client, zoneID, res[i].ID, name, ip)
				return
			}
		}
	}

	fmt.Printf("No such domain name: %v\n", name)
	fmt.Printf("Creating New Record...")
	createRecord(client, zoneID, name, ip)
}

func getIP() string {
	ipProvider := "https://api.ipify.org"
	res, err := http.Get(ipProvider)
	if err != nil {
		log.Fatalf("Error while requesting Public IP to %v: %v", ipProvider, err)
	}
	defer res.Body.Close()
	ip, err := io.ReadAll(res.Body)
	if err != nil {
		log.Fatalf("Error while reading response data from %v:  %v", ipProvider, err)
	}

	return string(ip)
}

func updateRecord(client *cloudflare.Client, zoneID, dnsRecordID, name, newIP string) {
	recordResponse, err := client.DNS.Records.Edit(
		context.TODO(),
		dnsRecordID,
		dns.RecordEditParams{
			ZoneID: cloudflare.F(zoneID),
			Body: dns.ARecordParam{
				Name:    cloudflare.F(name),
				TTL:     cloudflare.F(dns.TTL1),
				Type:    cloudflare.F(dns.ARecordTypeA),
				Content: cloudflare.F(newIP),
			},
		},
	)
	if err != nil {
		panic(err.Error())
	}
	fmt.Printf("%+v\n", recordResponse)
}

func createRecord(client *cloudflare.Client, zoneID, name, ip string) {
	recordResponse, err := client.DNS.Records.New(context.TODO(), dns.RecordNewParams{
		ZoneID: cloudflare.F(zoneID),
		Body: dns.ARecordParam{
			Name:    cloudflare.F(name),
			TTL:     cloudflare.F(dns.TTL1),
			Type:    cloudflare.F(dns.ARecordTypeA),
			Content: cloudflare.F(ip),
		},
	})
	if err != nil {
		panic(err.Error())
	}
	fmt.Printf("%+v\n", recordResponse)
}
