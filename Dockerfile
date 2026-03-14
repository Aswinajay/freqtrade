# Use the official Freqtrade image which already includes the Web UI
FROM freqtradeorg/freqtrade:stable

# Copy the local repository files into the image
# This ensures your strategies and custom configs are included
COPY --chown=ftuser:ftuser . /freqtrade/

# Ensure the user_data directory is present
RUN mkdir -p /freqtrade/user_data/

# We skip 'freqtrade install-ui' because it's already in the official image
# and avoids hitting GitHub API rate limits during the build on Render.

# Unset the official image's ENTRYPOINT to allow render.yaml to run full shell commands
ENTRYPOINT []
