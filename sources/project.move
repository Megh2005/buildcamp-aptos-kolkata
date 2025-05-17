module 0x3e9d94485fbde2339346df4c20770ec6001d7029ba57689e2a47e6cdb9a901c8::digital_patient_consent {
    use std::error;
    use std::signer;
    use std::string::{Self, String};
    use std::vector;
    use aptos_framework::account;
    use aptos_framework::event;
    use aptos_framework::timestamp;

    /// Errors
    const E_NOT_AUTHORIZED: u64 = 1;
    const E_PATIENT_NOT_REGISTERED: u64 = 2;
    const E_PROVIDER_NOT_REGISTERED: u64 = 3;
    const E_CONSENT_ALREADY_EXISTS: u64 = 4;
    const E_CONSENT_DOES_NOT_EXIST: u64 = 5;
    const E_CONSENT_ALREADY_REVOKED: u64 = 6;

    /// Structs 
    struct PatientRegistry has key {
        patients: vector<address>,
    }

    struct ProviderRegistry has key {
        providers: vector<address>,
    }

    struct Patient has key {
        id: address,
        name: String,
        date_of_birth: u64,
        active_consents: vector<u64>,
    }

    struct Provider has key {
        id: address,
        name: String,
        provider_type: String,
        consent_requests: vector<u64>,
    }

    struct Consent has key, store {
        id: u64,
        patient: address,
        provider: address,
        purpose: String,
        scope: String,
        granted_at: u64,
        expires_at: u64, // Timestamp in seconds when consent expires, 0 means no expiration
        is_active: bool,
        revoked_at: u64, // 0 means not revoked
    }

    struct ConsentCounter has key {
        counter: u64,
    }

    /// Events
    struct PatientRegisteredEvent has drop, store {
        patient_address: address,
        timestamp: u64,
    }

    struct ProviderRegisteredEvent has drop, store {
        provider_address: address,
        timestamp: u64,
    }

    struct ConsentGrantedEvent has drop, store {
        consent_id: u64,
        patient: address,
        provider: address,
        timestamp: u64,
    }

    struct ConsentRevokedEvent has drop, store {
        consent_id: u64,
        patient: address,
        provider: address,
        timestamp: u64,
    }

    struct EventHandles has key {
        patient_registered_events: event::EventHandle<PatientRegisteredEvent>,
        provider_registered_events: event::EventHandle<ProviderRegisteredEvent>,
        consent_granted_events: event::EventHandle<ConsentGrantedEvent>,
        consent_revoked_events: event::EventHandle<ConsentRevokedEvent>,
    }

    /// Initialization
    fun init_module(admin: &signer) {
        let admin_addr = signer::address_of(admin);
        
        // Initialize registries
        move_to(admin, PatientRegistry {
            patients: vector::empty<address>(),
        });

        move_to(admin, ProviderRegistry {
            providers: vector::empty<address>(),
        });

        // Initialize consent counter
        move_to(admin, ConsentCounter {
            counter: 0,
        });

        // Initialize event handles
        move_to(admin, EventHandles {
            patient_registered_events: account::new_event_handle<PatientRegisteredEvent>(admin),
            provider_registered_events: account::new_event_handle<ProviderRegisteredEvent>(admin),
            consent_granted_events: account::new_event_handle<ConsentGrantedEvent>(admin),
            consent_revoked_events: account::new_event_handle<ConsentRevokedEvent>(admin),
        });
    }

    /// Public functions
    public entry fun register_patient(patient: &signer, name: String, date_of_birth: u64, admin_addr: address) acquires PatientRegistry, EventHandles {
        let patient_addr = signer::address_of(patient);
        
        // Add patient to registry
        let registry = borrow_global_mut<PatientRegistry>(admin_addr);
        vector::push_back(&mut registry.patients, patient_addr);
        
        // Create patient record
        move_to(patient, Patient {
            id: patient_addr,
            name,
            date_of_birth,
            active_consents: vector::empty<u64>(),
        });
        
        // Emit event
        let event_handles = borrow_global_mut<EventHandles>(admin_addr);
        event::emit_event(&mut event_handles.patient_registered_events, PatientRegisteredEvent {
            patient_address: patient_addr,
            timestamp: timestamp::now_seconds(),
        });
    }

    public entry fun register_provider(provider: &signer, name: String, provider_type: String, admin_addr: address) acquires ProviderRegistry, EventHandles {
        let provider_addr = signer::address_of(provider);
        
        // Add provider to registry
        let registry = borrow_global_mut<ProviderRegistry>(admin_addr);
        vector::push_back(&mut registry.providers, provider_addr);
        
        // Create provider record
        move_to(provider, Provider {
            id: provider_addr,
            name,
            provider_type,
            consent_requests: vector::empty<u64>(),
        });
        
        // Emit event
        let event_handles = borrow_global_mut<EventHandles>(admin_addr);
        event::emit_event(&mut event_handles.provider_registered_events, ProviderRegisteredEvent {
            provider_address: provider_addr,
            timestamp: timestamp::now_seconds(),
        });
    }

    public entry fun grant_consent(
        patient: &signer,
        provider_addr: address,
        purpose: String,
        scope: String,
        expiration_time: u64,
        admin_addr: address
    ) acquires ConsentCounter, Patient, Provider, EventHandles {
        let patient_addr = signer::address_of(patient);
        
        // Verify patient is registered
        assert!(exists<Patient>(patient_addr), error::not_found(E_PATIENT_NOT_REGISTERED));
        
        // Verify provider is registered
        assert!(exists<Provider>(provider_addr), error::not_found(E_PROVIDER_NOT_REGISTERED));
        
        // Get consent ID
        let counter = borrow_global_mut<ConsentCounter>(admin_addr);
        let consent_id = counter.counter;
        counter.counter = consent_id + 1;
        
        // Create consent record
        let current_time = timestamp::now_seconds();
        let consent = Consent {
            id: consent_id,
            patient: patient_addr,
            provider: provider_addr,
            purpose,
            scope,
            granted_at: current_time,
            expires_at: expiration_time,
            is_active: true,
            revoked_at: 0,
        };
        
        // Update patient record
        let patient_record = borrow_global_mut<Patient>(patient_addr);
        vector::push_back(&mut patient_record.active_consents, consent_id);
        
        // Update provider record
        let provider_record = borrow_global_mut<Provider>(provider_addr);
        vector::push_back(&mut provider_record.consent_requests, consent_id);
        
        // Store consent in patient's account
        move_to(patient, consent);
        
        // Emit event
        let event_handles = borrow_global_mut<EventHandles>(admin_addr);
        event::emit_event(&mut event_handles.consent_granted_events, ConsentGrantedEvent {
            consent_id,
            patient: patient_addr,
            provider: provider_addr,
            timestamp: current_time,
        });
    }

    public entry fun revoke_consent(patient: &signer, consent_id: u64, admin_addr: address) acquires Consent, Patient, EventHandles {
        let patient_addr = signer::address_of(patient);
        
        // Verify patient is registered
        assert!(exists<Patient>(patient_addr), error::not_found(E_PATIENT_NOT_REGISTERED));
        
        // Verify consent exists
        assert!(exists<Consent>(patient_addr), error::not_found(E_CONSENT_DOES_NOT_EXIST));
        
        // Get consent record
        let consent = borrow_global_mut<Consent>(patient_addr);
        
        // Verify consent belongs to patient
        assert!(consent.patient == patient_addr, error::permission_denied(E_NOT_AUTHORIZED));
        
        // Verify consent is active
        assert!(consent.is_active, error::invalid_state(E_CONSENT_ALREADY_REVOKED));
        
        // Update consent record
        consent.is_active = false;
        consent.revoked_at = timestamp::now_seconds();
        
        // Update patient record by removing from active consents
        let patient_record = borrow_global_mut<Patient>(patient_addr);
        let (found, index) = vector::index_of(&patient_record.active_consents, &consent_id);
        if (found) {
            vector::remove(&mut patient_record.active_consents, index);
        };
        
        // Emit event
        let event_handles = borrow_global_mut<EventHandles>(admin_addr);
        event::emit_event(&mut event_handles.consent_revoked_events, ConsentRevokedEvent {
            consent_id,
            patient: patient_addr,
            provider: consent.provider,
            timestamp: consent.revoked_at,
        });
    }



    // View functions
    public fun get_patient_consents(patient_addr: address): vector<u64> acquires Patient {
        assert!(exists<Patient>(patient_addr), error::not_found(E_PATIENT_NOT_REGISTERED));
        
        let patient = borrow_global<Patient>(patient_addr);
        *&patient.active_consents
    }

    public fun get_provider_consents(provider_addr: address): vector<u64> acquires Provider {
        assert!(exists<Provider>(provider_addr), error::not_found(E_PROVIDER_NOT_REGISTERED));
        
        let provider = borrow_global<Provider>(provider_addr);
        *&provider.consent_requests
    }

    public fun is_consent_valid(patient_addr: address, consent_id: u64): bool acquires Consent {
        if (!exists<Consent>(patient_addr)) {
            return false
        };
        
        let consent = borrow_global<Consent>(patient_addr);
        if (consent.id != consent_id) {
            return false
        };
        
        if (!consent.is_active) {
            return false
        };
        
        let current_time = timestamp::now_seconds();
        if (consent.expires_at != 0 && current_time > consent.expires_at) {
            return false
        };
        
        true
    }
}