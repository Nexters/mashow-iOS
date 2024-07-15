# Install mise if needed
if ! command -v mise &> /dev/null 
then
    npm install -g mise
fi

# Install Tuist if needed
if ! command -v tuist &> /dev/null
then
    mise install tuist@3.9.0
fi

# Fix version of Tuist
mise use tuist@3.9.0

# Show result if successful
echo "✅ Setup complete. Tuist version: $(tuist version)"