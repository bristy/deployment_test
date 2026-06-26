<!-- OPENCLAW_DEPLOYMENT_BASELINE_v1 DO_NOT_EDIT -->
## Minimum Security Baseline (mandatory — cannot be removed or weakened)

These requirements apply to every OpenClaw deployment regardless of declared
intent. The Deployment Advisor must enforce them in addition to any goals below:

1. **No public plaintext HTTP** — block inbound port 80 from public sources;
   serve only over HTTPS/TLS.
2. **Run the OpenClaw container rootless** — non-root user, no privileged mode.
3. **No hardcoded credentials in the Terraform** — provider tokens and secrets
   must come from sensitive variables, never literals.
<!-- OPENCLAW_DEPLOYMENT_BASELINE_v1 DO_NOT_EDIT -->

# Deployment Goals: Security Scanning Runner

## Purpose and Workload

This deployment operates a security scanning runner that analyzes private repositories containing sensitive source code. The runner is hosted on a single compute instance running Ubuntu 22.04 in the NYC3 region with minimal resource allocation (1vCPU, 1GB RAM).

## Access Control Model

Administrative access to the instance is gated through a bastion host architecture. Direct SSH connections are authenticated using individual cryptographic keys assigned per administrator, with keys subject to rotation and expiry policies. The bastion model provides a controlled entry point for all administrative operations.

Repository access for scanning operations uses a cryptographic key with broad permissions across private repositories. Credentials and secrets required for runner operation are provided through environment variables configured manually during SSH sessions.

## Network Security Posture

The deployment implements restrictive network controls:

- Inbound traffic is limited to SSH connections on port 22
- Outbound HTTPS traffic (port 443) is restricted to a specific Cloudflare subnet range
- No general internet egress is permitted
- The firewall currently permits SSH from any source address

## Operational Practices

System maintenance follows a manual process where operating system and package updates are applied through SSH sessions. No automated logging aggregation, monitoring infrastructure, or intrusion detection capabilities are currently deployed. The deployment does not have documented incident response procedures.

## Security Objectives

**Immediate Priority:**

1. **Restrict SSH Source Addresses**: The SSH inbound rule must be narrowed from universal access to only the specific IP ranges of the bastion host infrastructure. This aligns the firewall policy with the intended bastion-gated access model.

2. **Protect Environment Variable Secrets**: Credentials stored in environment variables must be protected through appropriate file system permissions and excluded from any logging or command history mechanisms.

**High Priority:**

3. **Scope Repository Access Key**: The SSH key used for repository access should be replaced with deploy keys or scoped credentials that provide access only to the specific repositories requiring analysis, rather than broad permissions across all private repositories.

4. **Maintain Egress Restrictions**: The current outbound traffic limitation to the Cloudflare subnet should be preserved and verified to match only the required external services.

5. **Continue Key Rotation**: The existing practice of rotating SSH keys with expiry for bastion access must be maintained and documented.

**Medium Priority:**

6. **Implement Audit Logging**: System activity logs should be enabled and forwarded to a centralized logging service to provide an audit trail for security analysis and incident investigation.

7. **Document Update Schedule**: The manual update process should be formalized with a documented schedule and verification procedures to ensure timely security patching.

8. **Consider Intrusion Detection**: Given the sensitive nature of the workload (private repository analysis), evaluate implementing host-based intrusion detection to identify potential compromise or unauthorized activity.

## Risk Context

The deployment handles sensitive intellectual property through its access to private source code repositories. The combination of broad repository access credentials, manual operational processes, and limited visibility (no centralized logging or monitoring) creates risk if the instance is compromised. The current universal SSH access rule contradicts the intended bastion-gated architecture and should be corrected immediately.