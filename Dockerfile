# Use the official Freqtrade image which already includes the Web UI
FROM freqtradeorg/freqtrade:stable

# Copy the local repository files into the image
# This ensures your strategies and custom configs are included
COPY --chown=ftuser:ftuser . /freqtrade/

# Ensure the user_data directory is present and owned by ftuser
USER root
RUN mkdir -p /freqtrade/user_data/ && chown -R ftuser:ftuser /freqtrade/user_data/
USER ftuser

# We skip 'freqtrade install-ui' because it's already in the official image
# and avoids hitting GitHub API rate limits during the build on Render.
# However, we DO need to install PostgreSQL support and some missing dependencies for our strategies.
USER root
RUN pip install --no-cache-dir psycopg2-binary pandas-ta
USER ftuser

# Copy the entrypoint script and make it executable
COPY entrypoint-render.sh /freqtrade/
USER root
RUN chmod +x /freqtrade/entrypoint-render.sh
USER ftuser

# Use the custom entrypoint to handle Render's dynamic port and argument injection
ENTRYPOINT ["/freqtrade/entrypoint-render.sh"]

# Default command if not overridden (handles the 'trade' subcommand)
CMD ["trade", "--config", "config-render.json"]
