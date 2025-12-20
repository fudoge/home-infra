# Home infra
Personal infra workspace  

## Vaultwarden
![Architecture](architecture.svg)

For more information, visit [here](https://riveroverflow.pages.dev/p/%EC%A7%91%EC%97%90%EC%84%9C-vaultwarden%EC%9C%BC%EB%A1%9C-%EB%B9%84%EB%B0%80%EB%B2%88%ED%98%B8-%EC%84%9C%EB%B2%84-%EC%9A%B4%EC%98%81%ED%95%98%EA%B8%B0-w.-tailscale-vpn/)

## Agents

Agents are small, host-level programs that run on individual machines and are responsible for handling dynamic, host-specific tasks.

Unlike Terraform-managed infrastructure, agents operate in a reactive and state-independent manner.
They observe the local environment and apply changes when necessary.


### DDNS Agent
The DDNS agent updates the Cloudflare DNS record associated with the host when its public IP address changes.

Terraform is responsible for provisioning the DNS record itself.    
The DDNS agent is responsible for keeping its value up to date.

It can be used with systemd timer or cronjob.

## Services

Services are long-running, self-hosted applications that provide user-facing functionality.  
