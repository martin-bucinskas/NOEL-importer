cd sorted

for filename in *.dat; do
  echo "\"$filename\" => file:open(\"$filename\", [raw, append]),"
done
