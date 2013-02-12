##The Cucumber Signing Keys

This page lists the keys authorized to release Cucumber Artifacts. If your artifact isn't signed by a key listed on this page, it isn't genuine Cukes!

One Key to authorize them all, One Key to verify them,<br/>
One Key to sign them all and on this page list them.

```
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

pub   4096R/ED5D4477 2013-02-12 [expires: 2014-02-12]
      Key fingerprint = F94E D503 CC43 6D0A 9874  DDBB CE82 9C46 ED5D 4477
uid                  David Kowis (Cucumber Signing Key) <dkowis@shlrm.org>

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQGcBAEBAgAGBQJRGZnIAAoJEMnf+vRw63ObC1oL/AxW4qGs8n91zbwxXnG7KJ8P
zdY5n84aq+P0HpS2tcF6zzBQG7YKbmYOp+PM67G0mBNytZ94weaT+fqYZ/QDeGZT
0Gwz4GcDQ+egKL/JxV7LFZyyoeJtYjG8knGkyoHYKpgrW0X6VFrYUK3aLR4tcabs
0uorbporIxRTfUsdBmY3kn7m7S9jycDwytEhuDKpAaFr1P9uz6t5/4dZM66gxiJK
+cqlIRLhXTbHlwSRtr1nUn0oNwJCpkmIoek8SKge/KlXC/jbkVlEBPS6hBOy9aBN
EYjcSXNenU6JJfEeLfpLaF2WfbqiCUG6EMdbY7of8vtkx9ZGgGhbOqhv2M+uyX3Z
+1vPsrTmcwTgthTR+Ilek2YSpnkUiP7ZIOlmsPmZJm+xfA9lcPv5R4p+aqPbS2IQ
ZwhJgsTtqyo/EVpxp+94ZIM3jrfAayaBRHsp0RFvN845fzY0hMwCslkI2yB+Lnze
lpWuOR4KA6GlwoBRwl5GB2ZjuB6SDhw6aKcaD9n6bA==
=z0nP
-----END PGP SIGNATURE-----
```

The list of authorized keys should be signed by The Cucumber Key. 

To verify, checkout, or download this file, and run `gpg --verify <thisFile>`

It should report something close to:

```
$ gpg --verify KEYS.md 
gpg: Signature made Mon 11 Feb 2013 07:24:24 PM CST using RSA key ID 70EB739B
gpg: Good signature from "David Kowis <dkowis@shlrm.org>"
gpg:                 aka "David Kowis (My gmail address) <dkowis@gmail.com>"
```


###How to get on the list

Go through the items listed on [Developers](Developers.md) setting up all your accounts. Once you're an authorized releaser,
you'll use your signing key to release Cucumber artifacts. You will need to make a pull request adding the output of

```
gpg --fingerprint <yourKeyId>
```

to the end of [Releasers.txt](Releasers.txt). 
This list will then be signed by the owner of The Cucumber Key and this page will be updated.


###How to update the list

Export the section of the page with all the fingerprints on it, into a text file. Then execute

```
gpg --armor --default-key <TheCucumberKeyId> --clearsign Releasers.txt
```

This will output a `Releasers.txt.asc` that can be imported into this page for presentation and verification.
