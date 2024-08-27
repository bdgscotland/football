module.exports = {
    apps: [
      {
        name: 'user-service',
        script: './user-service/dist/main.js',
        watch: ['./user-service/src'],
        ignore_watch: ['node_modules', 'logs'],
        watch_options: {
          followSymlinks: false,
        },
        instances: 1,
        autorestart: true,
        max_memory_restart: '1G',
        env: {
          NODE_ENV: 'development',
        },
        env_production: {
          NODE_ENV: 'production',
        },
      },
      // Add more microservices here as needed
    ],
  };
  