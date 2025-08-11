module.exports = {
  apps: [{
    name: 'backend-pfe',
    script: 'dist/main.js',
    cwd: __dirname,
    instances: 1,
    autorestart: true,
    env: { NODE_ENV: 'production', PORT: 3000 }
  }]
};
