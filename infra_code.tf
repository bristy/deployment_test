###############################################################################
#  ⚠  INTENTIONALLY INSECURE — DEMO FIXTURE, NOT A TEMPLATE  ⚠
#
#  This config has ONE DELIBERATE flaw so the OpenClaw Deployment Advisor
#  can flag it and a live probe can prove it's reachable:
#    - SSH (22) open to 0.0.0.0/0  → FAILED  (CKV_DIO_4 / source-⊆-bastion)
#
#  Everything else matches declared intent, so the deterministic floor
#  PASSES and the scan routes the SSH goal to a tier (rather than
#  short-circuiting). The fixed version (../02-fixed/main.tf) is a
#  ONE-LINE diff: SSH source 0.0.0.0/0 → a single /32.
#
#  ❌ Do NOT copy this into a real deployment.
#  ❌ Do NOT leave the deployed droplet running — tear down within 2h
#     (see NEAR_LIVE_DEMO.md; run scripts/destroy_demo.sh).
###############################################################################

terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {
  type      = string
  sensitive = true
}

variable "ssh_fingerprint" {
  type        = string
  description = "Fingerprint of an SSH key already registered in your DigitalOcean account."
}

provider "digitalocean" {
  token = var.do_token
}

# An OpenClaw agent on a small droplet. The operator administers it over
# SSH and it calls OpenWeatherMap when a tool asks for weather data.
resource "digitalocean_droplet" "openclaw_runner" {
  name     = "openclaw-runner-demo"
  image    = "ubuntu-22-04-x64"
  region   = "nyc3"
  size     = "s-1vcpu-1gb"
  ssh_keys = [var.ssh_fingerprint]
  tags     = ["demo-openclaw-advisor"]
}

resource "digitalocean_firewall" "openclaw_firewall" {
  name        = "openclaw-firewall-demo"
  droplet_ids = [digitalocean_droplet.openclaw_runner.id]
  tags        = ["demo-openclaw-advisor"]

  # THE FLAW: SSH open to the entire internet. The engineer meant to scope
  # it to the bastion (198.51.100.10/32) but left it open "to get unblocked
  # during setup" and forgot to tighten it.
  #
  # This is the externally-PROVABLE flaw: `nmap -p 22 <droplet_ip>` from
  # any machine shows 22 reachable. It's the ONLY inbound rule, so whether
  # Trent routes it to Tier 1 (CKV_DIO_4) or Tier 2 (source ⊆ /32) the
  # verdict is the same: FAILED.
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }

  # Outbound to OpenWeatherMap (Cloudflare-fronted). Tight /16 that matches
  # the declared egress service — keeps the deterministic floor passing.
  outbound_rule {
    protocol              = "tcp"
    port_range            = "443"
    destination_addresses = ["104.16.0.0/16"]
  }
}

output "droplet_ipv4" {
  value = digitalocean_droplet.openclaw_runner.ipv4_address
}
