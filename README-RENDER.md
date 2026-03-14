# Freqtrade on Render.com (Free Tier)

This guide explains how to deploy and maintain your Freqtrade bot on Render.com using the free tier.

## 🚀 Quick Deployment

1. **Push configuration to your GitHub:**
   ```bash
   git add -f config-render.json render.yaml README-RENDER.md
   git commit -m "Add Render deployment setup"
   git push origin develop
   ```

2. **Deploy via Blueprints:**
   - Go to [Dashboard.render.com](https://dashboard.render.com).
   - Click **New +** > **Blueprint**.
   - Connect this repository.
   - Render will automatically create:
     - The **Freqtrade Bot** service.
     - A **PostgreSQL Database** for persistent trade history.

---

## 🔐 Credentials & Access

- **FreqUI URL**: Provided by Render (e.g., `https://freqtrade-bot-xxxx.onrender.com`).
- **Username**: `admin`
- **Password**: 
  - Go to your Render Dashboard.
  - Open the `freqtrade-bot` service.
  - Go to the **Environment** tab.
  - Look for the value of `FREQTRADE__API_SERVER__PASSWORD`.

---

## 🛠️ Maintenance & Limitations

### 1. Persistence
Your trades are saved in the **PostgreSQL** database. If the bot restarts or redeploys, your history remains safe. **Do not use SQLite** on Render, as the filesystem is ephemeral and your data will be lost.

### 2. Preventing "Sleep" (Keep Alive)
Render's free tier spins down services after 15 minutes of inactivity. To keep your bot trading 24/7:
- Use [UptimeRobot](https://uptimerobot.com/) or a similar service.
- Set up an **HTTP monitor** pointing to your Render URL.
- Set the interval to **12 minutes**.

### 3. RAM Limits
The free tier has **512MB RAM**. 
- Keep your `pair_whitelist` small (e.g., 5-10 pairs).
- Avoid complex strategies that require massive DataFrames.
- If the bot crashes with an "OOM" (Out of Memory) error, reduce the number of pairs or use a lighter strategy.

---

## 📈 Commands

- **Fetch updates from Global Repo**:
  ```bash
  git fetch upstream
  git merge upstream/develop
  ```
- **Push your changes**:
  ```bash
  git push origin develop
  ```

---

*Note: Accidental pushes to the global repository are blocked for safety.*
