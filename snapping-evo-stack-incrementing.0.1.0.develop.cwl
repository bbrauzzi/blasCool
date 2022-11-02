$namespaces:
  s: https://schema.org/
cwlVersion: v1.0
s:softwareVersion: 0.1.0
schemas:
  - http://schema.org/version/9.0/schemaorg-current-http.rdf
$graph:
  - class: Workflow
    doc: Increments an exixsting Stack
    id: stack-incrementing
    label: Increments a Stack
    inputs:
      stack_url:
        doc: The stack url, coming from an already-generated ifg stack
        label: The stack url, coming from an already-generated ifg stack
        type: string
      exclude_season:
        default: False
        doc: Exclude the season (True/False)
        label: Exclude the season (True/False)
        type: string?
      start_season:
        doc: First Month to Drop
        label: First Month to Drop
        type:
          - 'null'
          - type: enum
            symbols: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
      end_season:
        doc: Last Month to Drop
        label: Last Month to Drop
        type:
          - 'null'
          - type: enum
            symbols: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
      stopdate:
        doc: stop date for the IFG items to be generated
        label: stop date for the IFG items to be generated
        type: string
      platform:
        default: both
        doc: Scondary selection from catalog
        label: Scondary selection from catalog
        type:
          type: enum
          symbols: ["S1A", "S1B", "both"]
      wps_url:
        doc: URL of WPS
        label: URL of WPS
        type: string
      process_id:
        doc: Process ID
        label: Process ID
        type: string
      username:
        doc: Terradue username
        label: Terradue username
        type: string
      api_key:
        doc: Terradue api key
        label: Terradue api key
        type: string
      s3_bucket:
        doc: S3 bucket for results upload
        label: S3 bucket for results upload
        type: string
      force_creation:
        doc: Flag to force the creation of an existing DataItem (True/False)
        label: Flag to force the creation of an existing DataItem (True/False)
        type: string
    outputs:
      - id: wf_outputs
        outputSource:
          - step_1/results
        type: Directory
    steps:
      step_1:
        in:
          stack_url: stack_url
          exclude_season: exclude_season
          start_season: start_season
          end_season: end_season
          stopdate: stopdate
          platform: platform
          wps_url: wps_url
          process_id: process_id
          username: username
          api_key: api_key
          s3_bucket: s3_bucket
          force_creation: force_creation
        out:
          - results
        run: '#clt-stack-incrementing'
  - class: CommandLineTool
    baseCommand: snapping
    id: clt-stack-incrementing
    arguments:
      - ifg-stack-incrementing
    inputs:
      stack_url:
        inputBinding:
          position: 1
          prefix: --stack_url
        type: string
      exclude_season:
        inputBinding:
          position: 2
          prefix: --exclude_season
        type: string?
      start_season:
        inputBinding:
          position: 3
          prefix: --start_season
        type:
          - 'null'
          - type: enum
            symbols: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
      end_season:
        inputBinding:
          position: 4
          prefix: --end_season
        type:
          - 'null'
          - type: enum
            symbols: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
      stopdate:
        inputBinding:
          position: 5
          prefix: --stopdate
        type: string
      platform:
        inputBinding:
          position: 6
          prefix: --platform
        type:
          type: enum
          symbols: ["S1A", "S1B", "both"]
      wps_url:
        inputBinding:
          position: 7
          prefix: --wps
        type: string
      process_id:
        inputBinding:
          position: 8
          prefix: --pid
        type: string
      username:
        inputBinding:
          position: 9
          prefix: --username
        type: string
      api_key:
        inputBinding:
          position: 10
          prefix: --api_key
        type: string
      s3_bucket:
        inputBinding:
          position: 11
          prefix: --s3_bucket
        type: string
      force_creation:
        inputBinding:
          position: 12
          prefix: --force_creation
        type: string
    outputs:
      results:
        outputBinding:
          glob: .
        type: Directory
    requirements:
      EnvVarRequirement:
        envDef:
          PATH: /opt/conda/envs/env_snapping/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/srv/conda/envs/env_snapping/bin
      ResourceRequirement:
        coresMax: 1
        ramMax: 2048
      DockerRequirement:
        dockerPull: docker.terradue.com/snapping-evo:0.1.0-develop
