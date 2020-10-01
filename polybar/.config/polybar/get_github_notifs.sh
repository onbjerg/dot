#!/bin/bash

gh api notifications | jq '. | length'
