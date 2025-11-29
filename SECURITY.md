# Security Information

## Library Versions and Security

This project uses the following library versions, all updated to the latest stable releases with security patches as of December 2024:

| Library | Version | Security Notes |
|---------|--------|----------------|
| Apache HttpClient | 4.5.15 | Latest 4.5.x release with security patches |
| Apache HttpCore | 4.4.16 | Compatible with HttpClient 4.5.15 |
| Jackson Core | 2.17.1 | Latest stable, includes deserialization vulnerability fixes |
| Jackson Annotations | 2.17.1 | Latest stable |
| Jackson Databind | 2.17.1 | Latest stable, includes fixes for CVE-2020-36518 and other deserialization vulnerabilities |
| SLF4J API | 1.7.36 | Stable release (2.0.x has breaking changes) |
| Logback Core | 1.5.3 | Latest stable with security patches |
| Logback Classic | 1.5.3 | Latest stable with security patches |

## Known Security Improvements

### Jackson (Updated from 2.15.2 to 2.17.1)
- **CVE-2020-36518**: Fixed in 2.15.0+, further hardened in 2.17.x
- **CVE-2022-42003**: Fixed in 2.13.4+, further hardened in 2.17.x
- **CVE-2022-42004**: Fixed in 2.13.4+, further hardened in 2.17.x
- Multiple deserialization vulnerability fixes

### Apache HttpClient (Updated from 4.5.14 to 4.5.15)
- Bug fixes and minor security improvements
- Better handling of SSL/TLS connections

### Logback (Updated from 1.2.12 to 1.5.3)
- Security fixes for log injection vulnerabilities
- Improved handling of malicious log patterns
- Performance improvements

## Checking for Vulnerabilities

### Automated Scanning

Run the provided script:
```bash
./check-vulnerabilities.sh
```

### Manual Options

1. **OWASP Dependency-Check** (Recommended)
   ```bash
   # Download from: https://github.com/dependency-check/dependency-check/releases
   dependency-check.sh --scan lib --out . --format HTML
   ```

2. **Snyk**
   ```bash
   npm install -g snyk
   snyk test
   ```

3. **IntelliJ IDEA**
   - Code > Analyze Code > Show Vulnerable Dependencies

4. **Online Resources**
   - [National Vulnerability Database (NVD)](https://nvd.nist.gov/)
   - [Snyk Vulnerability DB](https://security.snyk.io/)
   - [Maven Central Security](https://central.sonatype.com/)

## Updating Libraries

To update to the latest secure versions:

```bash
# Remove old libraries (optional, script will overwrite)
rm -rf lib/*.jar

# Download latest versions
./download-libs.sh

# Rebuild project
./build.sh

# Check for vulnerabilities
./check-vulnerabilities.sh
```

## Security Best Practices

1. **Regular Updates**: Check for library updates monthly or when security advisories are published
2. **Vulnerability Scanning**: Run `./check-vulnerabilities.sh` regularly, especially after updates
3. **Monitor Advisories**: Subscribe to security advisories for all dependencies
4. **Use HTTPS**: Always use HTTPS for Jira API communications
5. **Secure Credentials**: Never commit credentials to version control
6. **Least Privilege**: Use Jira accounts with minimal required permissions

## Reporting Security Issues

If you discover a security vulnerability in this project:

1. **Do NOT** create a public GitHub issue
2. Contact the project maintainer directly
3. Provide detailed information about the vulnerability
4. Allow time for the issue to be addressed before public disclosure

## Compliance

These library versions have been selected to:
- Minimize known security vulnerabilities
- Maintain compatibility with Java 11+
- Provide stable, production-ready functionality
- Follow security best practices for Java applications

---

**Last Updated**: December 2024
**Next Review**: March 2025 (or when security advisories are published)

