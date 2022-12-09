$namespaces:
  s: https://schema.org/
cwlVersion: v1.0
s:softwareVersion: 0.1.4
schemas:
  - http://schema.org/version/9.0/schemaorg-current-http.rdf
$graph:
  - class: Workflow
    doc: Creates and queues interferograms
    id: stack-creation
    label: Creates a new Stack
    inputs:
      process_id:
        doc: Process ID
        label: Process ID
        type: string
      reference:
        doc: Reference Sentinel-1 SLC, max 2 continuous acquisitions
        label: Reference Sentinel-1 SLC, max 2 continuous acquisitions
        type: string[]
      dem:
        doc: DEM type to be applied
        label: DEM type to be applied
        type:
          - symbols: ["SRTM 3Sec", "SRTM 1Sec HGT"]
            type: enum
      platform:
        default: "both"
        doc: Scondary selection from catalog
        label: Scondary selection from catalog
        type:
          - type: enum
            symbols: ["S1A", "S1B", "both"]
      stack:
        doc: Interferometric stack title, no special char
        label: Interferometric stack title, no special char
        type: string
      stopdate:
        doc: stop date for the IFG items to be generated
        label: stop date for the IFG items to be generated
        type: string
      aoi:
        doc: Area of Interest
        label: Area of Interest
        type: string
      exclude_season:
        default: False
        doc: Exclude the season (True/False)
        label: Exclude the season (True/False)
        type: string?
      start_season:
        default: "NA"
        doc: First Month to Drop
        label: First Month to Drop
        type:
          - type: enum
            symbols: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "NA"]
      end_season:
        default: "NA"
        doc: Last Month to Drop
        label: Last Month to Drop
        type:
          - type: enum
            symbols: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "NA"]
      aoi_coreg:
        default: True
        doc: Coregistering with AOI
        label: Coregistering with AOI
        type: string?
      pol:
        default: VV
        doc: polarisation
        label: polarisation
        type: string?
      min_overlap:
        doc: 'Int value between 1-100: All S1 secondaries overlaping AOI < will be discarded'
        label: 'Int value between 1-100: All S1 secondaries overlaping AOI < will be discarded'
        type: string
      _T2Username:
        doc: Terradue username
        label: Terradue username
        type: string
      _T2ApiKey:
        doc: Terradue api key
        label: Terradue api key
        type: string
    outputs:
      - id: wf_outputs
        outputSource:
          - step_1/results
        type: Directory
    steps:
      step_1:
        in:
          process_id: process_id
          reference: reference
          dem: dem
          platform: platform
          stack: stack
          stopdate: stopdate
          aoi: aoi
          exclude_season: exclude_season
          start_season: start_season
          end_season: end_season
          aoi_coreg: aoi_coreg
          pol: pol
          min_overlap: min_overlap
          _T2Username: _T2Username
          _T2ApiKey: _T2ApiKey
        out:
          - results
        run: '#clt-stack-creation'
  - class: CommandLineTool
    baseCommand: snapping
    id: clt-stack-creation
    arguments:
      - ifg-stack-creation
      - --wps
      - "https://ades.snapping.terradue.com/snapping/zoo-bin/zoo_loader.cgi?"
      - --datapipeline
      - valueFrom: ${ return inputs._T2Username; }
      - --s3_bucket
      - "cpe-e2e-runs"
      - --force_creation
      - "False"
    inputs:
      process_id:
        inputBinding:
          position: 1
          prefix: --pid
        type: string
      reference:
        type:
          inputBinding:
            position: 2
            prefix: --reference
          items: string
          type: array
      dem:
        inputBinding:
          position: 3
          prefix: --dem
        type:
          symbols: ["SRTM 3Sec", "SRTM 1Sec HGT"]
          type: enum
      platform:
        inputBinding:
          position: 4
          prefix: --platform
        type:
          type: enum
          symbols: ["S1A", "S1B", "both"]
      stack:
        inputBinding:
          position: 5
          prefix: --stack
        type: string
      stopdate:
        inputBinding:
          position: 6
          prefix: --stopdate
        type: string
      aoi:
        inputBinding:
          position: 7
          prefix: --aoi
        type: string
      exclude_season:
        inputBinding:
          position: 8
          prefix: --exclude_season
        type: string?
      start_season:
        inputBinding:
          position: 9
          prefix: --start_season
        type:
          type: enum
          symbols: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "NA"]
      end_season:
        inputBinding:
          position: 10
          prefix: --end_season
        type:
          type: enum
          symbols: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "NA"]
      aoi_coreg:
        inputBinding:
          position: 11
          prefix: --aoi_coreg
        type: string?
      pol:
        inputBinding:
          position: 12
          prefix: --pol
        type: string?
      min_overlap:
        inputBinding:
          position: 13
          prefix: --min_overlap
        type: string
      _T2Username:
        inputBinding:
          position: 14
          prefix: --username
        type: string
      _T2ApiKey:
        inputBinding:
          position: 15
          prefix: --api_key
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
        dockerPull: docker.terradue.com/snapping-evo:0.1.4-develop
      InlineJavascriptRequirement: {}
