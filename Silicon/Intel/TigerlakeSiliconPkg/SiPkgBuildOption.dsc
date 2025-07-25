## @file
#  Silicon build option configuration file.
#
#  Copyright (c) 2021 - 2025, Intel Corporation. All rights reserved.<BR>
#  SPDX-License-Identifier: BSD-2-Clause-Patent
#
##

[BuildOptions]
# Define Build Options both for EDK and EDKII drivers.

  DEFINE PCH_BUILD_OPTIONS = -DPCH_TGL
#
# SA
#
!if gSiPkgTokenSpaceGuid.PcdBdatEnable == TRUE
  DEFINE BDAT_BUILD_OPTION = -DBDAT_SUPPORT=1
!else
  DEFINE BDAT_BUILD_OPTION =
!endif

  DEFINE SLE_BUILD_OPTIONS =
!if $(TARGET) == RELEASE
!if gSiPkgTokenSpaceGuid.PcdSiCatalogDebugEnable == TRUE
  DEFINE DEBUG_BUILD_OPTIONS =
!else
  # MDEPKG_NDEBUG is introduced for the intention
  # of size reduction when compiler optimization is disabled. If MDEPKG_NDEBUG is
  # defined, then debug and assert related macros wrapped by it are the NULL implementations.
  DEFINE DEBUG_BUILD_OPTIONS = -DMDEPKG_NDEBUG
!endif
!else
  DEFINE DEBUG_BUILD_OPTIONS =
!endif

!if ($(TARGET) == RELEASE) AND (gSiPkgTokenSpaceGuid.PcdSiCatalogDebugEnable == TRUE)
  DEFINE RELEASE_CATALOG_BUILD_OPTIONS = -DRELEASE_CATALOG
!else
  DEFINE RELEASE_CATALOG_BUILD_OPTIONS =
!endif

!if gSiPkgTokenSpaceGuid.PcdOptimizeCompilerEnable == FALSE
  DEFINE OPTIMIZE_DISABLE_OPTIONS = -Od -GL-
!else
  DEFINE OPTIMIZE_DISABLE_OPTIONS =
!endif

  DEFINE HSLE_BUILD_OPTIONS =


  DEFINE CPU_FLAGS = -DCPU_ICL -DCPU_TGL


  DEFINE RESTRICTED_OPTION =

!if gSiPkgTokenSpaceGuid.PcdMrcTraceMessageSupported == FALSE
  *_*_*_MRC_NDEBUG = -DMDEPKG_NDEBUG
!endif

DEFINE DSC_SIPKG_FEATURE_BUILD_OPTIONS = $(BDAT_BUILD_OPTION) $(DEBUG_BUILD_OPTIONS)
DEFINE DSC_SIPKG_FEATURE_BUILD_OPTIONS = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS) $(PCH_BUILD_OPTIONS) $(CPU_FLAGS) $(HSLE_BUILD_OPTIONS)

!if gSiPkgTokenSpaceGuid.PcdSourceDebugEnable == TRUE
  *_*_X64_GENFW_FLAGS = --keepexceptiontable
!endif

[BuildOptions.Common.EDKII]

#
# For IA32 Global Build Flag
#
       *_*_IA32_CC_FLAGS      = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS) -DASF_PEI
       *_*_IA32_VFRPP_FLAGS   = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS)
       *_*_IA32_APP_FLAGS     = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS)
       *_*_IA32_ASLPP_FLAGS   = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS)
       *_*_IA32_ASLCC_FLAGS   = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS)

#
# For IA32 Specific Build Flag
#
GCC:   *_*_IA32_PP_FLAGS      = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS)
MSFT:  *_*_IA32_ASM_FLAGS     = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS)
MSFT:  *_*_IA32_CC_FLAGS      = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS) $(OPTIMIZE_DISABLE_OPTIONS) -DASF_PEI /w34668
MSFT:  *_*_IA32_VFRPP_FLAGS   = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS) $(OPTIMIZE_DISABLE_OPTIONS)
MSFT:  *_*_IA32_APP_FLAGS     = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS) $(OPTIMIZE_DISABLE_OPTIONS)
MSFT:  *_*_IA32_ASLPP_FLAGS   = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS) $(OPTIMIZE_DISABLE_OPTIONS)
MSFT:  *_*_IA32_ASLCC_FLAGS   = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS) $(OPTIMIZE_DISABLE_OPTIONS)

#
# For X64 Global Build Flag
#
       *_*_X64_CC_FLAGS       = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS)
       *_*_X64_VFRPP_FLAGS    = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS)
       *_*_X64_APP_FLAGS      = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS)
       *_*_X64_ASLPP_FLAGS    = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS)
       *_*_X64_ASLCC_FLAGS    = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS)

#
# For X64 Specific Build Flag
#
GCC:   *_*_X64_PP_FLAGS       = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS)
MSFT:  *_*_X64_ASM_FLAGS      = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS)
MSFT:  *_*_X64_CC_FLAGS       = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS) $(OPTIMIZE_DISABLE_OPTIONS) /w34668
MSFT:  *_*_X64_VFRPP_FLAGS    = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS) $(OPTIMIZE_DISABLE_OPTIONS)
MSFT:  *_*_X64_APP_FLAGS      = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS) $(OPTIMIZE_DISABLE_OPTIONS)
MSFT:  *_*_X64_ASLPP_FLAGS    = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS)
MSFT:  *_*_X64_ASLCC_FLAGS    = $(DSC_SIPKG_FEATURE_BUILD_OPTIONS)

#
# For Xcode Specific Build Flag
#
# Override assembly code build order
*_XCODE5_*_*_BUILDRULEORDER = nasm S s
# Align 47bfbd7f8069e523798ef973c8eb0abd5c6b0746 to fix the usage of VA_START in undefined way
*_XCODE5_*_CC_FLAGS = -Wno-varargs

# Force PE/COFF sections to be aligned at 4KB boundaries to support page level protection of runtime modules
[BuildOptions.common.EDKII.DXE_RUNTIME_DRIVER]
  MSFT:       *_*_*_DLINK_FLAGS     = /ALIGN:4096 /FILEALIGN:4096
  GCC:        *_GCC*_*_DLINK_FLAGS  = -z common-page-size=0x1000
  CLANGPDB:   *_*_*_DLINK_FLAGS     = /ALIGN:4096 /FILEALIGN:4096
  CLANGDWARF: *_*_*_DLINK_FLAGS     = -z common-page-size=0x1000
