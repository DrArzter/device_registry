# Device Registry API

This is a Ruby on Rails API for managing device assignments to users, built as a technical assignment.

The API provides endpoints for assigning a device to a user and returning it, with business logic encapsulated in service objects and fully covered by tests.

---

## ⚙️ Technical Stack

- **Ruby:** 3.2.3  
- **Rails:** 7.1.3 (API-only mode)  
- **Database:** SQLite3  
- **Testing:** RSpec, FactoryBot, DatabaseCleaner  

---

## 🚀 Setup and Verification

To ensure the project is set up correctly, please follow these steps precisely. These instructions are designed to meet all the verification requirements mentioned in the assignment.

### 1. Set Ruby Version (Optional, if do not have Ruby installed)

This project is built and tested with Ruby 3.2.3.

```bash
# Example with rbenv
rbenv install 3.2.3
rbenv global 3.2.3
```

### 2. Clone the Repository

```bash
git clone https://github.com/DrArzter/device_registry
```

### 3. Install Dependencies

```bash
cd device_registry
bundle install
```

### 4. Update Shell Command Shims (Optional)

To ensure that the new gems are available in your `PATH`, run the following command:

```bash
# If using rbenv
rbenv rehash
```

> **Note for RVM users:** This step is not necessary, as `rvm` handles this automatically.

### 5. Create and Prepare the Database

```bash
rails db:create
rails db:migrate
rake db:test:prepare
```

> **Note:** The `rake db:test:prepare` command is included to meet an explicit requirement of the assignment.  
> In modern Rails, this step is typically handled automatically by RSpec's configuration.



---

## ✅ Running the Test Suite

After a successful setup, run the test suite:

```bash
rspec spec
```

**Recommended for development:**

```bash
bundle exec rspec
```

---

## 📡 API Usage Examples

All endpoints require an `Authorization: Bearer <token>` header. You can create a test user and an API key from the Rails console.

### 1. Start Rails Console

```bash
rails c
```

### 2. Create a Test User

```ruby
user = User.create!(email: 'test@example.com', password: 'password123')
```

### 3. Create a Device

```ruby
device = Device.create!(serial_number: 'SN-TEST-001')
```

### 4. Create an API Key for the User

```ruby
api_key = ApiKey.create!(bearer: user)
```

### 5. Assign the Device to the User

```bash
curl -X POST http://localhost:3000/api/v1/devices/assign \
     -H "Authorization: Bearer <your_token>" \
     -H "Content-Type: application/json" \
     -d '{ "device": { "serial_number": "SN-TEST-001" } }'
```

### 6. Unassign the Device from the User

```bash
curl -X POST http://localhost:3000/api/v1/devices/unassign \
     -H "Authorization: Bearer <your_token>" \
     -H "Content-Type: application/json" \
     -d '{ "device": { "serial_number": "SN-TEST-001" } }'
```

> **Reminder:** Make sure to run `rails s` in a separate terminal to start the server when testing the API with `curl`.

---
