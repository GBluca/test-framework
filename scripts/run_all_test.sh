#!/bin/bash

for f in ~/test-framework/tests/*.xml;do
    echo "validazione $f"
    xmllint --noout --schema ~/test-framework/schemas/test_schemas.xsd $f
done 