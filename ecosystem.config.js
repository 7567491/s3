module.exports = {
  apps: [
    {
      name: 'www-bucket-viewer',
      script: 'npm',
      args: 'run dev',
      cwd: '/home/www/www',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '500M',
      env: {
        NODE_ENV: 'development',
        PORT: 15080
      },
      log_file: '/var/log/www-bucket-viewer.log',
      out_file: '/var/log/www-bucket-viewer-out.log',
      error_file: '/var/log/www-bucket-viewer-error.log',
      time: true,
      restart_delay: 5000,
      max_restarts: 10,
      min_uptime: '10s',
      kill_timeout: 3000,
      listen_timeout: 8000,
      health_check_http: 'http://localhost:15080/',
      health_check_grace_period: 10000
    }
  ]
}