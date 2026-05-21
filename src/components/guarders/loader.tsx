import type React from "react";
import Spinner from "../spinner/main";


interface GuardLoaderProps {
  isLoading: boolean; 
  children: React.ReactNode;
  fallback?: React.ReactNode
};


export default function GuardLoader (props:GuardLoaderProps){
  if(props.isLoading ) {
    return props.fallback || <Spinner />
  } 

  return props.children;
}




