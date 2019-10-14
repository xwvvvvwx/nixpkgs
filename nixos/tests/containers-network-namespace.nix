import ./make-test.nix {

  machine =
    { config, pkgs, ... }:
    {
      networking.namespaces = [ "test" ];

      containers.test = {
        autoStart = true;
        networkNamespace = "test";
        config = { ... }: {};
      };
    };

  testScript =
    ''
      $machine->start;
      $machine->waitForUnit('default.target');
      $machine->succeed('ip netns') =~ /test/ or die;
      $machine->succeed('ip link add dummy1 type dummy');
      $machine->succeed('ip link set netns test dummy1');
      $machine->succeed('machinectl shell root@test /run/current-system/sw/bin/ip link show dummy1') =~ /dummy1: <BROADCAST,NOARP> mtu/ or die;
    '';
}
