# 🏥 Digital Patient Consent System on Aptos 🔒

![Aptos Move](https://img.shields.io/badge/Aptos-Move-purple)
![License](https://img.shields.io/badge/License-MIT-green)

## 📋 Overview

This smart contract provides a decentralized solution for managing patient consent in healthcare settings. Built on the Aptos blockchain using the Move language, it offers secure, transparent, and auditable patient consent management.

## 🌟 Key Features

- ✅ **Secure Patient Registration**: Patients can create and manage their digital identity
- 🏢 **Provider Verification**: Healthcare providers can register and be verified  
- 📝 **Granular Consent Management**: Patients control who can access their data and for what purpose
- ⏰ **Time-bound Access Control**: Support for consent expiration dates
- 📊 **Comprehensive Audit Trail**: Immutable record of all consent activities
- 🔍 **Consent Verification**: Easy verification of valid consent

## 🔧 Installation & Setup

### Prerequisites

- [Aptos CLI](https://aptos.dev/cli-tools/aptos-cli-tool/install-aptos-cli)
- [Move Compiler](https://github.com/move-language/move)

### Deployment Steps

1. Clone this repository:
```bash
git clone https://github.com/yourusername/digital-patient-consent.git
cd digital-patient-consent
```

2. Compile the Move module:
```bash
aptos move compile
```

3. Deploy to the Aptos blockchain:
```bash
aptos move publish --named-addresses deployer=YOUR_ADDRESS
```

### Deployment Results

A successful deployment will generate a response similar to:
```json
{
  "Result": {
    "transaction_hash": "0x05025b9426e859eb8aa6c93182a25051f0ec20c172221629aca1116d821456df",
    "gas_used": 5194,
    "gas_unit_price": 100,
    "sender": "3e9d94485fbde2339346df4c20770ec6001d7029ba57689e2a47e6cdb9a901c8",
    "sequence_number": 0,
    "success": true,
    "timestamp_us": 1747467898259530,
    "version": 6460559,
    "vm_status": "Executed successfully"
  }
}
```

## 📖 Contract Explanation

### Core Components

#### 📊 Data Structures

1. **PatientRegistry & ProviderRegistry**
   - Central registries tracking all participants in the system
   - Essential for system-wide queries and management

2. **Patient**
   - Stores patient identity and active consents
   - Each patient manages their own consent records

3. **Provider**
   - Contains healthcare provider information and consent requests
   - Providers can only access data with explicit patient consent

4. **Consent**
   - The core data structure capturing the consent relationship
   - Includes purpose, scope, timestamps, and status information

5. **Event System**
   - Ensures all actions are recorded on the blockchain for auditability

#### 🔄 Key Functions

1. **register_patient**
   - Creates a new patient record in the system
   - Emits a registration event for auditability

2. **register_provider**
   - Adds a healthcare provider to the system
   - Providers must be registered before requesting consent

3. **grant_consent**
   - Allows patients to explicitly grant consent to providers
   - Specifies purpose, scope, and optional expiration

4. **revoke_consent**
   - Patients can withdraw consent at any time
   - Immediately terminates provider access rights

5. **check_consent**
   - Verification function to check if valid consent exists
   - Used by providers before accessing patient data

## 🔍 Code Walkthrough

### Module Structure

```move
module 0x1::digital_patient_consent {
    // Imports, structs, and functions
}
```

The module uses Aptos standard libraries and implements a comprehensive consent management system.

### Error Codes

```move
/// Errors
const E_NOT_AUTHORIZED: u64 = 1;
const E_PATIENT_NOT_REGISTERED: u64 = 2;
// ...and more
```

Clear error codes ensure proper error handling and meaningful feedback.

### Events System

```move
struct PatientRegisteredEvent has drop, store {
    patient_address: address,
    timestamp: u64,
}
// ...other events
```

Events provide auditability and can trigger off-chain notifications or actions.

### Initialization

```move
fun init_module(admin: &signer) {
    // Initialize registries, counters, and event handles
}
```

Sets up all necessary components when the module is first deployed.

### Security Considerations

- All functions verify appropriate authorization before execution
- Consent records are immutable once created (can only be revoked, not modified)
- Timestamps ensure consent validity periods are properly enforced

## 💻 Usage Example

### Patient Registration

```move
// Register a new patient
public entry fun register_patient(patient: &signer, "John Doe", 19900101, @admin);
```

### Provider Registration

```move
// Register a healthcare provider
public entry fun register_provider(provider: &signer, "General Hospital", "Hospital", @admin);
```

### Consent Management

```move
// Patient grants consent to a provider
public entry fun grant_consent(
    patient, 
    @provider, 
    "Medical Treatment", 
    "Full Medical Records", 
    1672531200, // Expiration timestamp
    @admin
);

// Patient revokes consent
public entry fun revoke_consent(patient, consent_id, @admin);

// Provider checks if consent is valid
public entry fun check_consent(provider, @patient, consent_id);# 🏥 Digital Patient Consent System on Aptos 🔒

![Healthcare Blockchain](https://img.shields.io/badge/Healthcare-Blockchain-blue)
![Aptos Move](https://img.shields.io/badge/Aptos-Move-purple)
![License](https://img.shields.io/badge/License-MIT-green)

## 📋 Overview

This smart contract provides a decentralized solution for managing patient consent in healthcare settings. Built on the Aptos blockchain using the Move language, it offers secure, transparent, and auditable patient consent management.

## 🌟 Key Features

- ✅ **Secure Patient Registration**: Patients can create and manage their digital identity
- 🏢 **Provider Verification**: Healthcare providers can register and be verified  
- 📝 **Granular Consent Management**: Patients control who can access their data and for what purpose
- ⏰ **Time-bound Access Control**: Support for consent expiration dates
- 📊 **Comprehensive Audit Trail**: Immutable record of all consent activities
- 🔍 **Consent Verification**: Easy verification of valid consent

## 🔧 Installation & Setup

### Prerequisites

- [Aptos CLI](https://aptos.dev/cli-tools/aptos-cli-tool/install-aptos-cli)
- [Move Compiler](https://github.com/move-language/move)

### Deployment Steps

1. Clone this repository:
```bash
git clone https://github.com/yourusername/digital-patient-consent.git
cd digital-patient-consent
```

2. Compile the Move module:
```bash
aptos move compile
```

3. Deploy to the Aptos blockchain:
```bash
aptos move publish --named-addresses deployer=YOUR_ADDRESS
```

## 📖 Contract Explanation

### Core Components

#### 📊 Data Structures

1. **PatientRegistry & ProviderRegistry**
   - Central registries tracking all participants in the system
   - Essential for system-wide queries and management

2. **Patient**
   - Stores patient identity and active consents
   - Each patient manages their own consent records

3. **Provider**
   - Contains healthcare provider information and consent requests
   - Providers can only access data with explicit patient consent

4. **Consent**
   - The core data structure capturing the consent relationship
   - Includes purpose, scope, timestamps, and status information

5. **Event System**
   - Ensures all actions are recorded on the blockchain for auditability

#### 🔄 Key Functions

1. **register_patient**
   - Creates a new patient record in the system
   - Emits a registration event for auditability

2. **register_provider**
   - Adds a healthcare provider to the system
   - Providers must be registered before requesting consent

3. **grant_consent**
   - Allows patients to explicitly grant consent to providers
   - Specifies purpose, scope, and optional expiration

4. **revoke_consent**
   - Patients can withdraw consent at any time
   - Immediately terminates provider access rights

5. **check_consent**
   - Verification function to check if valid consent exists
   - Used by providers before accessing patient data

## 🔍 Code Walkthrough

### Module Structure

```move
module 0x1::digital_patient_consent {
    // Imports, structs, and functions
}
```

The module uses Aptos standard libraries and implements a comprehensive consent management system.

### Error Codes

```move
/// Errors
const E_NOT_AUTHORIZED: u64 = 1;
const E_PATIENT_NOT_REGISTERED: u64 = 2;
// ...and more
```

Clear error codes ensure proper error handling and meaningful feedback.

### Events System

```move
struct PatientRegisteredEvent has drop, store {
    patient_address: address,
    timestamp: u64,
}
// ...other events
```

Events provide auditability and can trigger off-chain notifications or actions.

### Initialization

```move
fun init_module(admin: &signer) {
    // Initialize registries, counters, and event handles
}
```

Sets up all necessary components when the module is first deployed.

### Security Considerations

- All functions verify appropriate authorization before execution
- Consent records are immutable once created (can only be revoked, not modified)
- Timestamps ensure consent validity periods are properly enforced

## 💻 Usage Example

### Patient Registration

```move
// Register a new patient
public entry fun register_patient(patient: &signer, "John Doe", 19900101, @admin);
```

### Provider Registration

```move
// Register a healthcare provider
public entry fun register_provider(provider: &signer, "General Hospital", "Hospital", @admin);
```

### Consent Management

```move
// Patient grants consent to a provider
public entry fun grant_consent(
    patient, 
    @provider, 
    "Medical Treatment", 
    "Full Medical Records", 
    1672531200, // Expiration timestamp
    @admin
);

// Patient revokes consent
public entry fun revoke_consent(patient, consent_id, @admin);

// Provider checks if consent is valid
public entry fun check_consent(provider, @patient, consent_id);
```

## 🔒 Security Considerations

- 🛡️ **Access Control**: Functions verify appropriate authorization
- 🔐 **Immutable Records**: Consent records cannot be modified after creation
- ⏳ **Time-based Validation**: Expiration timestamps enforce time-limited consent
- 🔍 **Explicit Verification**: Providers must verify consent before access

## 🚀 Future Enhancements

1. **Delegation Support**: Allow patients to delegate consent management to trusted parties
2. **Consent Templates**: Standardized templates for common medical procedures
3. **Multi-signature Consent**: Require multiple parties to approve certain consent types
4. **Integration with DIDs**: Support for decentralized identifiers
5. **Privacy-Preserving Features**: Zero-knowledge proofs for verification without revealing data

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

⚠️ **Disclaimer**: This smart contract is provided as a reference implementation and should undergo thorough security auditing before production use in healthcare settings.