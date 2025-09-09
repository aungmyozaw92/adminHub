# AdminHub

A comprehensive admin dashboard built with Ruby on Rails featuring user management, role-based authentication, and modern UI.

## Features

- 🔐 **Authentication System**: Secure login/logout with session management
- 👥 **User Management**: Complete CRUD operations for users
- 🎭 **Role-Based Access**: Multiple user roles (Admin, Manager, User, Moderator)
- 🎨 **Modern UI**: Clean, responsive design with Tailwind CSS
- 📱 **Mobile Friendly**: Responsive layout that works on all devices
- 🔧 **Admin Dashboard**: Overview with stats, charts, and activity feeds

## Tech Stack

- **Backend**: Ruby on Rails 7
- **Frontend**: Tailwind CSS, Stimulus, Turbo
- **Database**: SQLite (development)
- **Authentication**: Session-based with bcrypt
- **Asset Pipeline**: Propshaft, esbuild

## Getting Started

### Prerequisites
- Ruby 3.1+
- Rails 7+
- Node.js 16+
- npm or yarn

### Installation

1. Clone the repository
```bash
git clone https://github.com/YOUR_USERNAME/adminhub.git
cd adminhub
```

2. Install dependencies
```bash
bundle install
npm install
```

3. Setup database
```bash
rails db:migrate
rails db:seed
```

4. Build assets
```bash
npm run build:css
npm run build
```

5. Start the server
```bash
rails server
```

Visit `http://localhost:3000` to access the admin dashboard.

## Default Login Credentials

After running `rails db:seed`, you can login with:

- **Admin**: admin@example.com / password123
- **Manager**: manager@example.com / password123
- **User**: user@example.com / password123

## Project Structure

```
app/
├── controllers/admin/     # Admin controllers
├── views/admin/          # Admin views
├── models/               # User, Role, UserRole models
└── helpers/admin/        # Admin helpers

config/
├── routes.rb             # Application routes
└── database.yml          # Database configuration

db/
├── migrate/              # Database migrations
└── seeds.rb              # Seed data
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License.