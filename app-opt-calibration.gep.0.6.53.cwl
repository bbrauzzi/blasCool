$graph:
- baseCommand: opt-calibration
  class: CommandLineTool
  hints:
    DockerRequirement:
      dockerPull: docker.terradue.com/opt-calibration:gep0.6.53
  id: clt
  inputs:
    input_path:
      inputBinding:
        position: 1
        prefix: --input_path
      type: Directory
  outputs:
    results:
      outputBinding:
        glob: .
      type: Directory
  requirements:
    EnvVarRequirement:
      envDef:
        APP_DOCKER_IMAGE: docker.terradue.com/opt-calibration:gep0.6.53
        APP_NAME: opt-calibration
        APP_PACKAGE: app-opt-calibration.gep.0.6.53
        APP_VERSION: 0.6.53
        GDAL_CACHEMAX: '4096'
        GDAL_NUM_THREADS: ALL_CPUS
        LC_NUMERIC: C
        LD_LIBRARY_PATH: /srv/conda/envs/env_opt_calibration/conda-otb/lib/:/opt/anaconda/envs/env_opt_calibration/lib/:/usr/lib64
        OTB_APPLICATION_PATH: /srv/conda/envs/env_opt_calibration/conda-otb/lib/otb/applications
        OTB_MAX_RAM_HINT: '8192'
        PATH: /srv/conda/envs/env_opt_calibration/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/srv/conda/envs/env_opt_calibration/bin
        PREFIX: /srv/conda/envs/env_opt_calibration
        PYTHONPATH: /srv/conda/envs/env_opt_calibration/conda-otb/lib/python
        _PROJECT: GEP
    ResourceRequirement:
      coresMax: 4
      ramMax: 16384
  stderr: std.err
  stdout: std.out
- class: Workflow
  doc: This service provides calibrated images from optical EO data products. Optical
    calibrated products in output can be used as input for further thematic processing
    (e.g. co-location, co-registration).
  id: opt-calibration
  inputs:
    input_path:
      doc: Optical acquisition
      label: Optical acquisition
      type: Directory[]
  label: Optical Products Calibration
  outputs:
  - id: wf_outputs
    outputSource:
    - step_1/results
    type:
      items: Directory
      type: array
  requirements:
  - class: ScatterFeatureRequirement
  steps:
    step_1:
      in:
        input_path: input_path
      out:
      - results
      run: '#clt'
      scatter: input_path
      scatterMethod: dotproduct
$namespaces:
  s: https://schema.org/
cwlVersion: v1.0
s:softwareVersion: 0.6.53
schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf

