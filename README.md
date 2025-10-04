# Secure Web API Project

## Overview

This project implements a secure web API using Python and Flask framework with JWT authentication and comprehensive security measures. The API provides user authentication and protected data endpoints while incorporating multiple security best practices.

## Task Implementation Summary

### 1. Project Stack and Initialization
- **Technology Stack**: Python with Flask framework
- **Package Management**: pip with requirements.txt
- **Version Control**: Git repository initialized and connected to remote
- **Database**: SQLite for simplicity with SQLAlchemy ORM

### 2. Functional API Development
Implemented three API endpoints:
1. **POST /auth/login** - User authentication endpoint
2. **GET /api/data** - Protected data endpoint (requires authentication)
3. **GET /api/users** - Additional protected endpoint to list users

### 3. Security Implementation
- **SQL Injection Protection**: Used SQLAlchemy ORM with parameterized queries
- **XSS Protection**: Implemented output escaping using Flask's `escape()` function
- **Authentication Security**:
  - JWT tokens with expiration for authentication
  - Password hashing using bcrypt algorithm
  - Middleware for JWT verification on protected endpoints

### 4. CI/CD Pipeline with Security Scanning
- Configured GitHub Actions workflow (.github/workflows/ci.yml)
- Implemented SAST (Static Application Security Testing) using Bandit
- Implemented SCA (Software Composition Analysis) using Safety
- Automated security scans on every push and pull request

### 5. Testing and Documentation
- Created comprehensive test script (test_jwt.sh) for API testing
- Verified authentication functionality with curl and Postman
- Security scanning reports generated and reviewed

## Project Structure

```
secure-api/
├── app.py                 # Main Flask application
├── config.py             # Configuration settings
├── requirements.txt      # Python dependencies
├── test_jwt.sh          # Bash script for API testing
├── .github/
│   └── workflows/
│       └── ci.yml       # GitHub Actions CI/CD configuration
└── README.md            # This file
```

## Key Files Description

### app.py
Main Flask application containing:
- User model definition with password hashing
- JWT configuration and middleware
- API endpoints implementation:
  - POST /auth/login - User authentication
  - GET /api/data - Protected data endpoint
  - GET /api/users - Protected user listing endpoint
- Database initialization

### config.py
Configuration settings for the application including:
- Secret keys for Flask and JWT
- Database connection URI
- Environment-specific configurations

### requirements.txt
Lists all Python dependencies:
- Flask web framework
- Flask-SQLAlchemy for database ORM
- Flask-JWT-Extended for JWT authentication
- Bcrypt for password hashing

### test_jwt.sh
Bash script for comprehensive API testing:
- Tests login functionality
- Verifies JWT token generation
- Tests access to protected endpoints
- Tests security measures (invalid tokens, missing authentication)
- Provides color-coded output for easy verification

### .github/workflows/ci.yml
GitHub Actions configuration for CI/CD pipeline:
- Automated security scanning on push and pull requests
- Bandit SAST scanning for Python code
- Safety SCA scanning for dependency vulnerabilities
- Artifact generation for security reports

## Setup and Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd secure-api
```

2. Create and activate virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

4. Run the application:
```bash
python app.py
```

## Testing

### Manual Testing with curl
```bash
# Get JWT token
curl -X POST -H "Content-Type: application/json" -d '{"username":"admin","password":"password123"}' http://localhost:5000/auth/login

# Access protected endpoint (replace <token> with actual JWT)
curl -H "Authorization: Bearer <token>" http://localhost:5000/api/data
```

### Automated Testing
Run the comprehensive test script:
```bash
chmod +x test_jwt.sh
./test_jwt.sh
```


This project demonstrates a secure API implementation with comprehensive security measures, automated testing, and CI/CD integration for ongoing security monitoring.