ASN ranges:
ASN0xxxxx: Emergency documents
(./ASNGen.sh $(pwd)/out --font-size=2mm --bw=5 --bc=90a5d6 --hw=2 --hc=e75662 -s 0)

ASN1xxxxx: Legal/Government/Contracts
(./ASNGen.sh $(pwd)/out --font-size=2mm --bw=5 --bc=90a5d6 --hw=2 --hc=4c5a7d -s 100000)

ASN9xxxxx: Everything else
(./ASNGen.sh $(pwd)/out --font-size=2mm --bw=5 --bc=90a5d6 --hw=2 --hc=a89c94 -s 900000)


Command template is:
./ASNGen.sh $(pwd)/out --font-size=2mm --bw=5 --bc=(person color) --hw=2 --hc=(Category hex color) -s (first ASN)
