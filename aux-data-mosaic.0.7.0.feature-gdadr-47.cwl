$graph:
  - baseCommand: mosaic
    class: CommandLineTool
    id: clt
    inputs:
      aoi:
        inputBinding:
          position: 1
          prefix: --aoi
        type: string
      layer:
        type:
          type: enum
          symbols:
            - "ESA World Cover"
            - "Copernicus DEM World Cover"
            - "DLR World Settlement Footprint"
            - "World Population"
            - "JRC Global Surface Water - Change"
            - "JRC Global Surface Water - Extent"
            - "JRC Global Surface Water - Occurrence"
            - "JRC Global Surface Water - Recurrence"
            - "JRC Global Surface Water - Seasonality"
            - "JRC Global Surface Water - Transitions"
    arguments:
      - --buffer
      - "0.05"
      - valueFrom: ${ if (inputs.layer == "ESA World Cover") { return ["--esa-world-cover"]; } if (inputs.layer == "Copernicus DEM World Cover") { return ["--cop-dem"]; } if (inputs.layer == "JRC Global Surface Water - Change") { return ["--global-surface-water", "--layer", "change"]} if (inputs.layer == "JRC Global Surface Water - Extent") { return ["--global-surface-water", "--layer", "extent"]} if (inputs.layer == "JRC Global Surface Water - Occurrence") { return ["--global-surface-water", "--layer", "occurrence"]} if (inputs.layer == "JRC Global Surface Water - Recurrence") { return ["--global-surface-water", "--layer", "recurrence"]} if (inputs.layer == "JRC Global Surface Water - Seasonality") { return ["--global-surface-water", "--layer", "seasonality"]} if (inputs.layer == "JRC Global Surface Water - Transitions") { return ["--global-surface-water", "--layer", "transitions"]} if (inputs.layer == "DLR World Settlement Footprint") { return ["--world-settlement-footprint"]; } if (inputs.layer == "World Population") { return ["--world-population"]; } }
    outputs:
      results:
        outputBinding:
          glob: .
        type: Directory
    requirements:
      EnvVarRequirement:
        envDef:
          APP_VERSION: 0.3.9
          PATH: /opt/conda/bin:/opt/conda/envs/env_mosaic/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/conda/envs/env_mosaic/bin
          PROJ_LIB: /opt/conda/envs/env_mosaic/share/proj/
      ResourceRequirement: {}
      InlineJavascriptRequirement: {}
      DockerRequirement:
        dockerPull: docker.terradue.com/aux-mosaic:0.7.0-feature-gdadr-47
  - class: Workflow
    doc: 'Aux data mosaic generation'
    id: aux-data-mosaic
    inputs:
      aoi:
        doc: Area of interest in WKT
        label: Area of interest
        type: string
      layer:
        doc: Layer to process
        label: Layer to process
        type:
          type: enum
          symbols:
            - "ESA World Cover"
            - "Copernicus DEM World Cover"
            - "DLR World Settlement Footprint"
            - "World Population"
            - "JRC Global Surface Water - Change"
            - "JRC Global Surface Water - Extent"
            - "JRC Global Surface Water - Occurrence"
            - "JRC Global Surface Water - Recurrence"
            - "JRC Global Surface Water - Seasonality"
            - "JRC Global Surface Water - Transitions"
    label: mosaic
    outputs:
      - id: wf_outputs
        outputSource:
          - step_1/results
        type: Directory
    steps:
      step_1:
        in:
          aoi: aoi
          layer: layer
        out:
          - results
        run: '#clt'
cwlVersion: v1.0
$namespaces:
  s: https://schema.org/
schemas:
  - http://schema.org/version/9.0/schemaorg-current-http.rdf
s:softwareVersion: 0.2.0
