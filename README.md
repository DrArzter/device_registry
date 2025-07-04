# Device Registry API

A Ruby on Rails API for managing device assignments to users, built as a technical assignment.

It provides endpoints to assign/unassign devices to/from users. Business logic is encapsulated in service objects, and the project is fully covered by tests.

---

## ⚙️ Technical Stack

- **Ruby:** 3.2.3  
- **Rails:** 7.1.3 (API-only mode)  
- **Database:** SQLite3  
- **Testing:** RSpec, FactoryBot, DatabaseCleaner  

---

## 🚀 Setup & Verification

Follow these steps to set up the project locally.

The project was tested with Arch Linux. It should also work on other Linux distributions if you have the necessary dependencies installed and PATH is set up correctly for rbenv or RVM.

### 1. Install Ruby (if needed)

The project uses Ruby **3.2.3**.

```bash
# Using rbenv (example)
rbenv install 3.2.3
rbenv global 3.2.3
```

You may also want to add rbenv to your fish or zsh or sh configuration.

```bash
# Fish example
set -gx PATH $HOME/.rbenv/bin $PATH
status --is-interactive; and source (rbenv init -|psub)
```

You can also use [RVM](https://rvm.io/) instead.

### 2. Clone the Repository

```bash
git clone https://github.com/DrArzter/device_registry
cd device_registry
```

### 3. Install Dependencies

```bash
bundle install
```

### 4. Update Shell Shims (if using rbenv)

Ensures your shell recognizes installed binaries:

```bash
rbenv rehash
```

> 💡 **Note for RVM users:** This step is not needed.

### 5. Set Up the Database

```bash
rails db:create
rails db:migrate
rake db:test:prepare
```

> 📌 `rake db:test:prepare` is explicitly required by the assignment, even though modern Rails handles test DB setup automatically via RSpec.

---

## ✅ Running the Test Suite

To verify the setup and run tests:

```bash
rspec spec
```

**Recommended:**

```bash
bundle exec rspec
```

---

## 📡 API Usage Examples

All endpoints require an `Authorization: Bearer <token>` header. You can create a test user and API key using the Rails console.

### 1. Open Rails Console

```bash
rails c
```

### 2. Prepare Test Data

Run the following in the console to create a user, a device, and an API key:

```ruby
user = User.create!(email: 'test@example.com', password: 'password123')
device = Device.create!(serial_number: 'SN-TEST-001')
api_key = ApiKey.create!(bearer: user)

puts "---"
puts "✅ Setup Complete! Use these values for API testing:"
puts "API TOKEN (copy this): #{api_key.token}"
puts "Device Serial Number: #{device.serial_number}"
puts "---"
```

### 3. Start the Server

In a separate terminal:

```bash
rails s
```

### 4. Test the API with `curl`

> 📌 Use the token from the console output above.

In a separate terminal:

#### 4.1 Assign a Device

```bash
curl -X POST http://localhost:3000/api/v1/devices/assign \
     -H "Authorization: Bearer <your_token>" \
     -H "Content-Type: application/json" \
     -d '{ "device": { "serial_number": "SN-TEST-001" } }'
```

#### 4.2 Unassign a Device

```bash
curl -X POST http://localhost:3000/api/v1/devices/unassign \
     -H "Authorization: Bearer <your_token>" \
     -H "Content-Type: application/json" \
     -d '{ "device": { "serial_number": "SN-TEST-001" } }'
```

---

