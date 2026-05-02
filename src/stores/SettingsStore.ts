import { create } from "zustand"
import { getGroups, getYears } from "../api/settings"





const useSettings = create((set) => ({
  groups: [],
  years: [],
  init: async () => {
    const [groups,years] = await Promise.all([getGroups(),getYears()])
    set({ groups,years });
  }
}))

export default useSettings




