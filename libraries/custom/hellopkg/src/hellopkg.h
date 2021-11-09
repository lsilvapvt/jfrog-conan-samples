#pragma once

#ifdef WIN32
  #define hellopkg_EXPORT __declspec(dllexport)
#else
  #define hellopkg_EXPORT
#endif

hellopkg_EXPORT void hellopkg();
