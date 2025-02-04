
You can create a Cloudflare WAF (Web Application Firewall) rule to allow only your IP address to access rancher. Follow these steps:

1. Log in to Cloudflare
Go to Cloudflare Dashboard and select your domain (jtmb.cc).

2. Navigate to WAF Rules
Click on Security > WAF > Custom Rules.
3. Create a New WAF Rule
Click Create Rule.

Rule Name: `Allow Only My IP for Rancher`

Expression Editor: 

Use the following filter expression:
```
(http.host eq "YOUR_RANCHER_ADDRESS" and ip.src ne YOUR_IP_ADDRESS)
Replace YOUR_IP_ADDRESS with your actual public IP.
```
4. Action
Set Action to Block (This blocks everyone except your IP).
5. Deploy the Rule
Click Deploy Rule to activate it.
Alternative: Using Managed Rules
If you have Cloudflare Zero Trust (Access), you can configure Access Policies to require login or enforce stricter security measures.