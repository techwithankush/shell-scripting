#!/bin/bash

# Define variables
APP_DIR="/path/to/your/application"  # Replace with the actual path to your Node.js application directory
UNIT_TEST_DIR="$APP_DIR/tests/unit"  # Replace with the path to your unit tests directory
INTEGRATION_TEST_DIR="$APP_DIR/tests/integration"  # Replace with the path to your integration tests directory
E2E_TEST_DIR="$APP_DIR/tests/e2e"  # Replace with the path to your end-to-end tests directory
APP_PORT=3000  # Replace with the port number your application listens on

# Function to run unit tests
run_unit_tests() {
    cd $UNIT_TEST_DIR
    npm install  # Install test dependencies if needed
    npm test
}

# Function to run integration tests
run_integration_tests() {
    # Start the application on a specific port
    cd $APP_DIR
    PORT=$APP_PORT npm start &
    APP_PID=$!

    # Wait for the application to be ready
    until curl -s http://localhost:$APP_PORT; do
        sleep 1
    done

    # Run integration tests
    cd $INTEGRATION_TEST_DIR
    npm install  # Install test dependencies if needed
    npm test

    # Stop the application
    kill $APP_PID
}

# Function to run end-to-end tests
run_e2e_tests() {
    # Start the application on a specific port
    cd $APP_DIR
    PORT=$APP_PORT npm start &
    APP_PID=$!

    # Wait for the application to be ready
    until curl -s http://localhost:$APP_PORT; do
        sleep 1
    done

    # Run end-to-end tests
    cd $E2E_TEST_DIR
    npm install  # Install test dependencies if needed
    npm run test:ci

    # Stop the application
    kill $APP_PID
}

# Call the functions to run tests
run_unit_tests
run_integration_tests
run_e2e_tests

echo "All tests completed successfully!"
