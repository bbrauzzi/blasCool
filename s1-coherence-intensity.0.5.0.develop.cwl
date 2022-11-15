cwlVersion: v1.0

$namespaces:
  s: https://schema.org/
s:softwareVersion: 0.5.0
schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf


$graph:
- class: Workflow

  id: s1-coherence-intensity
  label: Coherence and Intensity Composite
  doc: This service computes coherence and backscatter from an interferometric pair and produces a band composite of coherence and backscatter average. It also generates a red-cyan composite of backscatter from reference and secondary.

  requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: SubworkflowFeatureRequirement

  inputs:

    reference: 
      type: Directory[]
      label: Reference SLC dataset
    secondary:
      type: Directory[]
      label: Secondary SLC dataset  
    aoi: 
      type: string?
      label: Area of interest as WKT
    
  outputs:
  - id: coin
    outputSource:
    - node_graphista/coin
    type: Directory
  steps:

    node_graphista:
      in:
        reference: reference
        secondary: secondary
        aoi: aoi
          
      out:
      - coin

      run: "#graphista"

- class: CommandLineTool

  id: graphista
  label: generates the coherence and intensity for S1 SLC 

  requirements: 
    DockerRequirement:
      dockerPull: docker.terradue.com/graphista:dev0.8.12
    ResourceRequirement:
      coresMax: 4
      ramMax: 32000
    InlineJavascriptRequirement: {}
    InitialWorkDirRequirement:
      listing:
        - entryname: custom.vmoptions
          entry: |-
            # Enter one VM parameter per line
            # Initial memory allocation
            -Xms16G
            # Maximum memory allocation
            -Xmx32G
            # Disable verifier
            -Xverify:none
            # Turns on point performance optimizations
            -XX:+AggressiveOpts
            # disable some drawing driver useless in server mode
            -Dsun.java2d.noddraw=true
            -Dsun.awt.nopixfmt=true
            -Dsun.java2d.dpiaware=false
            # larger tile size to reduce I/O and GC
            -Dsnap.jai.defaultTileSize=1024
            -Dsnap.dataio.reader.tileWidth=1024
            -Dsnap.dataio.reader.tileHeigh=1024
            # disable garbage collector overhead limit
            -XX:-UseGCOverheadLimit
        - entryname: run_me.sh
          entry: |-
            #!/bin/bash
            reference=$1
            
            mkdir -p /tmp/work 
            cd /tmp/work

            graphista run "$@"

            cd - 

            Stars copy -r 4 -rel -o ./ /tmp/work/catalog.json
            
            rm -fr .cache .config .install4j

  baseCommand: ["/bin/bash", "run_me.sh"]
 

  arguments:
  - --recipe
  - "s1-coherence-intensity"
  - valueFrom: |
      ${
        var references=[];
        for (var i = 0; i < inputs.reference.length; i++) {
          references.push("--reference");
          references.push(inputs.reference[i].path);
        }
        return references;
      }
  - valueFrom: |
      ${
        var secondaries=[];
        for (var i = 0; i < inputs.secondary.length; i++) {
          secondaries.push("--secondary");
          secondaries.push(inputs.secondary[i].path);
        }
        return secondaries;
      }
  - valueFrom: |
      ${ if ( inputs.aoi == null ) {
          return "--empty"
        } else {
          return ["--Subset", "geoRegion=" + inputs.aoi];
        }
      }

  inputs: 
    reference:
      type: Directory[]
    secondary: 
      type: Directory[]
    aoi: 
      type: string?

  outputs:
    coin:
      type: Directory
      outputBinding:
        glob: .
