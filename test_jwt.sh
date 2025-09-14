#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
BASE_URL="http://localhost:5000"
LOGIN_ENDPOINT="/auth/login"
PROTECTED_ENDPOINT="/api/data"
USERS_ENDPOINT="/api/users"

# Test credentials
USERNAME="admin"
PASSWORD="admin"

echo -e "${YELLOW}Starting JWT Security Tests...${NC}"
echo "=========================================="

# Test 1: Login and get JWT token
echo -e "${YELLOW}Test 1: Login and get JWT token${NC}"
response=$(curl -s -X POST -H "Content-Type: application/json" \
  -d "{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\"}" \
  "$BASE_URL$LOGIN_ENDPOINT")

# Extract token from response
token=$(echo $response | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)

if [ -n "$token" ]; then
  echo -e "${GREEN}✓ Successfully obtained JWT token${NC}"
  echo "Token: $token"
else
  echo -e "${RED}✗ Failed to obtain JWT token${NC}"
  echo "Response: $response"
  exit 1
fi

echo ""

# Test 2: Access protected endpoint with valid token
echo -e "${YELLOW}Test 2: Access protected endpoint with valid token${NC}"
response=$(curl -s -w "%{http_code}" -H "Authorization: Bearer $token" \
  "$BASE_URL$PROTECTED_ENDPOINT")

# Extract status code and body
status_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | sed '$d')

if [ "$status_code" -eq 200 ]; then
  echo -e "${GREEN}✓ Successfully accessed protected endpoint${NC}"
  echo "Response: $body"
else
  echo -e "${RED}✗ Failed to access protected endpoint${NC}"
  echo "Status Code: $status_code"
  echo "Response: $body"
fi

echo ""

# Test 3: Access protected endpoint without token
echo -e "${YELLOW}Test 3: Access protected endpoint without token${NC}"
response=$(curl -s -w "%{http_code}" "$BASE_URL$PROTECTED_ENDPOINT")

# Extract status code and body
status_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | sed '$d')

if [ "$status_code" -eq 401 ]; then
  echo -e "${GREEN}✓ Correctly blocked access without token${NC}"
  echo "Response: $body"
else
  echo -e "${RED}✗ Unexpected response when accessing without token${NC}"
  echo "Status Code: $status_code"
  echo "Response: $body"
fi

echo ""

# Test 4: Access protected endpoint with invalid token
echo -e "${YELLOW}Test 4: Access protected endpoint with invalid token${NC}"
response=$(curl -s -w "%{http_code}" -H "Authorization: Bearer invalid_token_here" \
  "$BASE_URL$PROTECTED_ENDPOINT")

# Extract status code and body
status_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | sed '$d')

if [ "$status_code" -eq 422 ] || [ "$status_code" -eq 401 ]; then
  echo -e "${GREEN}✓ Correctly rejected invalid token${NC}"
  echo "Response: $body"
else
  echo -e "${RED}✗ Unexpected response with invalid token${NC}"
  echo "Status Code: $status_code"
  echo "Response: $body"
fi

echo ""

# Test 5: Access users endpoint with valid token
echo -e "${YELLOW}Test 5: Access users endpoint with valid token${NC}"
response=$(curl -s -w "%{http_code}" -H "Authorization: Bearer $token" \
  "$BASE_URL$USERS_ENDPOINT")

# Extract status code and body
status_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | sed '$d')

if [ "$status_code" -eq 200 ]; then
  echo -e "${GREEN}✓ Successfully accessed users endpoint${NC}"
  echo "Response: $body"
else
  echo -e "${RED}✗ Failed to access users endpoint${NC}"
  echo "Status Code: $status_code"
  echo "Response: $body"
fi

echo ""
echo -e "${YELLOW}Testing completed!${NC}"