{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.drlg.powerManagement;
in
{
  options.drlg.powerManagement = {
    enable = lib.mkEnableOption "Enable custom power management";
    preventSleep = lib.mkEnableOption "Prevent sleep";
    preventHddSpindown = lib.mkEnableOption "Prevent hard drive spindown";
    disableApst = lib.mkEnableOption "Disable Advanced Power Management State Transitions (Only for NVMe drives)";
    disableAspm = lib.mkEnableOption "Disable Active State Power Management for PCIe";
    disableUsbAutosuspend = lib.mkEnableOption "Disable USB autosuspend";
    restrictCpuCStates = lib.mkEnableOption "Restrict CPU/package C-states to C1 for lower latency";
    disablePowertopAutoTune = lib.mkEnableOption "Disable powertop auto-tune";
    disableTlp = lib.mkEnableOption "Disable TLP";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = !(cfg.preventHddSpindown && config.services.tlp.enable);
            message = ''
              drlg.powerManagement.preventHddSpindown is enabled, but services.tlp.enable is also enabled.
              TLP may override disk power settings. Disable TLP or disable preventHddSpindown.
            '';
          }
        ];
      }

      (lib.mkIf cfg.preventSleep {
        systemd.sleep.settings.Sleep = {
          AllowSuspend = false;
          AllowHibernation = false;
          AllowHybridSleep = false;
          AllowSuspendThenHibernate = false;
        };

        systemd.targets.sleep.enable = false;
        systemd.targets.suspend.enable = false;
        systemd.targets.hibernate.enable = false;
        systemd.targets.hybrid-sleep.enable = false;
      })

      (lib.mkIf cfg.disableUsbAutosuspend {
        boot.kernelParams = [
          "usbcore.autosuspend=-1"
        ];
      })

      (lib.mkIf cfg.disableAspm {
        boot.kernelParams = [
          "pcie_aspm=off"
        ];
      })

      (lib.mkIf cfg.disableApst {
        boot.kernelParams = [
          "nvme_core.default_ps_max_latency_us=0"
        ];

        services.udev.extraRules = ''
          # Disable NVMe APST for all NVMe controllers.
          ACTION=="add|change", SUBSYSTEM=="nvme", KERNEL=="nvme[0-9]*", \
            RUN+="${pkgs.bash}/bin/sh -c 'echo 0 > /sys/class/nvme/%k/device/power/control'"
        '';
      })

      (lib.mkIf cfg.restrictCpuCStates {
        boot.kernelParams = [
          "processor.max_cstate=1"
          "intel_idle.max_cstate=1"
        ];
      })

      (lib.mkIf cfg.preventHddSpindown {
        environment.systemPackages = [
          pkgs.hdparm
        ];

        services.udev.extraRules = ''
          # Prevent rotational disks from spinning down.
          ACTION=="add|change", SUBSYSTEM=="block", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", \
            RUN+="${pkgs.hdparm}/bin/hdparm -B 254 -S 0 /dev/%k"
        '';
      })

      (lib.mkIf cfg.disablePowertopAutoTune {
        powerManagement.powertop.enable = false;
      })

      (lib.mkIf cfg.disableTlp {
        services.tlp.enable = false;
      })
    ]
  );
}
