CONFIG_FILE="${config_file}"
TEMP_FILE=$(mktemp)

if [ -f "$CONFIG_FILE" ]; then
  echo "Config file already exists, skipping..."
else
  echo "Creating $CONFIG_FILE"

  cat <<EOL > "$CONFIG_FILE"
  <Config>
    <AuthenticationMethod>External</AuthenticationMethod>
    <AuthenticationRequired>DisabledForLocalAddresses</AuthenticationRequired>
    <ApiKey>${api_key}</ApiKey>
  </Config>
EOL

  echo "Config file created"
fi
