az network nsg rule create -g <resource-grou-name> --nsg-name <nsg-name> -n <rule-name> `
    --priority 100 --destination-address-prefixes '<ip-address>' --destination-port-ranges <port-number> `
    --access <allow/deny> --protocol '<tcp/udp>'