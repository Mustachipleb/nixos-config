# This module defines a systemd service to generate .env files from templates
# using environment variables defined in an agenix secret.
# It processes all .env.template files in a specified directory and outputs them to /etc/env
# with appropriate permissions.

{
  config,
  pkgs,
  ...
}: {
  # Define your agenix secret
  age.secrets."dragonlegion.be.env".file = ../../common/secrets/dragonlegion.be.age;
  age.secrets.synologySmbCredentials.file = ../../common/secrets/synology.smb.credentials.age;

  # Systemd service to generate the config file
  systemd.services.env-substitutions = {
    description = "Generate .envs from template";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Group = "root";
      EnvironmentFile = config.age.secrets."dragonlegion.be.env".path;
      ExecStart = pkgs.writeShellScript "env-substitutions" ''
        set -euxo pipefail

        mkdir -p /etc/env
        chmod 0700 /etc/env

        # Find and process all .env.template files
        template_dir="${/home/mustachio/nixos-config/common/secrets/templates}"

        # clear previous env files
        rm -f /etc/env/*.env

        # Loop through all .env.template files in the templates directory
        for template_file in "$template_dir"/*.env.template; do
          # Skip if no matching files found
          [ -f "$template_file" ] || continue

          # Extract filename without path and change extension
          basename_file=$(basename "$template_file" .template)
          output_file="/etc/env/$basename_file"

          echo "Processing template: $template_file -> $output_file"

          # envsubst will use the values from EnvironmentFile
          ${pkgs.gettext}/bin/envsubst < "$template_file" > "$output_file"

          # Set permissions for each generated file
          chmod 0400 "$output_file"
          chown root:root "$output_file"
        done
      '';
    };

    serviceConfig = {
      ProtectSystem = "strict";
      ProtectHome = true;
      NoNewPrivileges = true;
      PrivateTmp = true;
      CapabilityBoundingSet = "";
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      ProtectHostname = true;
      ProtectClock = true;
      ProtectKernelLogs = true;
      ReadWritePaths = [ "/etc/env" ]; # allow writing config.json
    };
  };
}
