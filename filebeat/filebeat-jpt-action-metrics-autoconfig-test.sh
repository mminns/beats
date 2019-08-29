#!/bin/sh
NEW_YAML=$1.new.yml
cp $1 $NEW_YAML

#filebeat.inputs:
#- type: log
#  enabled: true
#  paths:
#    # this is the default location of the logs on the VU hosts
#    - ${HOME}/test-results/*/action-metrics.jpt

echo "filebeat.inputs.1.type: log" | sudo tee -a $NEW_YAML
echo "filebeat.inputs.1.enabled: true" | sudo tee -a $NEW_YAML
echo "filebeat.inputs.1.paths.0: ${HOME}/test-results/*/action-metrics.jpt" | sudo tee -a $NEW_YAML

echo "setup.kibana.host: '34.253.121.248:5601'" | sudo tee -a $NEW_YAML
echo "output.elasticsearch.hosts: ['34.253.121.248:9200']" | sudo tee -a $NEW_YAML

#processors:
#  - add_host_metadata: ~
#  - add_cloud_metadata: ~
#  - decode_json_fields:
#      fields: ["message"]
#      target: "actionMetric"
#  - script:
#      lang: javascript
#      id: parseDuration
#      file: ${path.config}/parseDuration.js
echo "processors.2.decode_json_fields.fields: 'message']" | sudo tee -a $NEW_YAML
echo "processors.2.decode_json_fields.target: 'actionMetric'" | sudo tee -a $NEW_YAML

./filebeat test config -c $NEW_YAML 2> $NEW_YAML.error

if [ -s $NEW_YAML.error ]
then
     echo ""
     echo "BOOOOOOOOOOOOM!!!!!"
     cat $NEW_YAML.error
else
     echo "Success!"
     echo "Run $./filebeat run config -c $NEW_YAML"
fi

