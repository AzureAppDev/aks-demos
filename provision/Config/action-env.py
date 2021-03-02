import sys

environment = sys.argv[1]
region_name = sys.argv[2]
app_code = sys.argv[3]
version = sys.argv[4]

def regionCode(region_name):
    return f"{region_name[0:1]}{region_name[-1:]}"

def resourceEnv(app_code, version, env):
    return f"{app_code}-env{version}-{env}"

def resourceEnvCompact(app_code, version, env):
    return f"{app_code}env{version}{env}"

def outputVariable(output_name, value):
    print(f"::set-output name={output_name}::{value}")

key_vault_name = f"kv-{resourceEnv(app_code, version, environment)}"
registry_name = f"acr{resourceEnvCompact(app_code, version, environment)}"
registry_group_name = f"rg-{resourceEnv(app_code, version, environment)}"

outputVariable("key_vault_name", key_vault_name)
outputVariable("registry_name", registry_name)
outputVariable("registry_group_name", registry_group_name)



