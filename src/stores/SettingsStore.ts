import { create } from "zustand"
import { getGroups, getYears } from "../api/settings"
import type { Group, Year } from "../types/settings"



interface ScState{
  groups: Group[],
  years: Year[],
  init: () => Promise<void>
}


const useSettings = create<ScState>((set) => ({
  groups: [],
  years: [],
  init: async () => {
    const [groups,years] = await Promise.all([getGroups(),getYears()])
    set({ groups,years });
  }
}))

export default useSettings;


