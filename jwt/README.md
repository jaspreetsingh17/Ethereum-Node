# JWT Secret for Engine API

## Overview

Since Ethereum's transition to Proof of Stake (The Merge), the execution client (Geth) and consensus client must communicate via the Engine API. This communication is authenticated using a shared JWT secret.

## Generating the Secret

The JWT secret is a 32-byte hex string. Generate it with:

```bash
openssl rand -hex 32 > jwt.hex
```

## Security

- Keep this file secure and only readable by the Geth and consensus client users
- Do not commit real JWT secrets to version control
- Use proper file permissions (600)

```bash
chmod 600 jwt.hex
```

## Usage

Both clients must be configured to use the same JWT secret file:

**Geth**:
```bash
geth --authrpc.jwtsecret=/path/to/jwt.hex
```

**Lighthouse** (consensus client example):
```bash
lighthouse bn --execution-jwt=/path/to/jwt.hex
```

**Prysm** (consensus client example):
```bash
prysm beacon-chain --jwt-secret=/path/to/jwt.hex
```

## Troubleshooting

If you see authentication errors:
1. Verify both clients point to the same jwt.hex file
2. Check file permissions
3. Ensure the file contains exactly 64 hex characters
4. Try regenerating the secret and restarting both clients
