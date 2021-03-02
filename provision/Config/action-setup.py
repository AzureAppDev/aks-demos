import sys

environment = sys.argv[1]
region_name = sys.argv[2]
app_code = sys.argv[3]
version = sys.argv[4]

def regionCode(region_name):
    return f"{region_name[0:1]}{region_name[-1:]}"

def resourceName(app_code, version, env):
    return f"{app_code}-{version}-{regionCode(region_name)}-{env}"

def outputVariable(output_name, value):
    print(f"::set-output name={output_name}::{value}")

resource_group_name = f"rg-{resourceName(app_code, version, environment)}"
log_analytics_name = f"logs-{resourceName(app_code, version, environment)}"
aks_cluster_name = f"aks-{resourceName(app_code, version, environment)}"

outputVariable("region_name", region_name)
outputVariable("resource_group_name", resource_group_name)
outputVariable("log_analytics_name", log_analytics_name)
outputVariable("aks_cluster_name", aks_cluster_name)

