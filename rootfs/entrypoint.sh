#!/bin/bash
set -e

bootstrap() {
	while ! nc -z localhost ${PORT:-8538}; do sleep 0.5; done
	# TOPICS="topic1 topic2"
	# SUB_NAMES="sub1=url1,sub11 sub2"
	subs=($SUB_NAMES)
	i=0
	for topic in $TOPICS; do
		echo "Creating topic $topic"
		curl -fsSLX PUT http://localhost:${PORT:-8538}/v1/projects/${PROJECT_ID:-project-id}/topics/$topic
		
		IFS=','
		read -a topicSubs <<< "${subs[i]}"
		for sub in ${topicSubs[@]}; do
			PUSH_ENDPOINT=${sub##*=}
			sub=${sub%%=*}
			[[ "$PUSH_ENDPOINT" == "$sub" ]] && PUSH_ENDPOINT=
			
			curl -fsSLX PUT \
			http://localhost:${PORT:-8538}/v1/projects/${PROJECT_ID:-project-id}/subscriptions/${sub} \
			-H 'Content-Type: application/json' \
			--data-binary @- <<-JSON
				{
					"topic": "projects/${PROJECT_ID:-project-id}/topics/$topic",
					"ackDeadlineSeconds": ${ACK_DEADLINE:-10},
					"pushConfig": {
						"pushEndpoint": "${PUSH_ENDPOINT}"
					}
				}
			JSON
		done
		i=$i+1
	done
}

# create topics with two subscriptions each as soon as the emulator is up
bootstrap &

if [[ -z "$@" ]]; then
	[[ ! -d "${DATADIR:-/data}" ]] && mkdir -p "${DATADIR:-/data}"
	exec gcloud beta emulators pubsub start --host-port=0.0.0.0:${PORT:-8538} --data-dir=${DATADIR:-/data} --project=${PROJECT_ID:-project-id}
else
	exec "$@"
fi