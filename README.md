# Coindesk BPI retriever

Trivial tool to grab the Bitcoin Price Index from Coindesk for display in an xmobar docklet.

Example invocation in .xmobarrc:

```haskell
Run Com "/home/lucca/.local/bin/coindesk-bpi" [] "btc" 18000
```

This will retrieve the exchange rate every 30 minutes.

Example output:

```text
2650.6775 at 02:00
```

# Caveats

* No caching or rate-limiting, so be very careful how the refresh is configured.
* Missing most error checking because it isn't needed in my use-case.
