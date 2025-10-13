function main(config) {
  const fakeIpFilter = [
    "+.rustdesk.com",
    ...config["dns"]["fake-ip-filter"]
  ];
  const nameserverPolicy = {
    "+.local":"system",
    "+.rustdesk.com":"https://223.5.5.5/dns-query#skip-cert-verify=true",
    ...config["dns"]["nameserver-policy"]
  };
  const rules = [
    "AND,((IP-CIDR,23.94.117.180/32),(DST-PORT,65533)),DIRECT",
    "DOMAIN-SUFFIX,rustdesk.com,DIRECT",
    "PROCESS-PATH-REGEX,.*rustdesk,DIRECT",
    ...config.rules
  ]
  config["dns"]["fake-ip-range"] = "100.64.0.1/10";
  config["dns"]["fake-ip-filter"] = fakeIpFilter;
  config["dns"]["nameserver-policy"] = nameserverPolicy;
  config["rules"] = rules;
  return config;
}
