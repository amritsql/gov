#!/bin/bash
aws s3 sync . s3://mys3bucksg --exclude "*.py" --exclude "*.sh" --exclude "*.bash" --delete --exact-timestamps

