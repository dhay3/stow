function main(config) {
  const rules = [
    "AND,((IP-CIDR,23.94.117.180/32),(DST-PORT,65533)),DIRECT",
    "DOMAIN-SUFFIX,rustdesk.com,DIRECT",
    "PROCESS-PATH-REGEX,.*rustdesk,DIRECT",
    ...config.rules
  ]
  config["rules"] = rules 
  return config;
}
