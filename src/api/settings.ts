
import type { Group, Year } from "../types/settings"

const DEFAULT_YEARS: Year[] = [
  { id: 1, title: "2023-2024" },
  { id: 2, title: "2024-2025" }
];

const DEFAULT_GROUPS: Group[] = [
  { id: 1, title: "ПОВТ-23" },
  { id: 2, title: "ИБ-23" },
  { id: 3, title: "Э-23" }
];

export const getYears = async (): Promise<Year[]> => {
  // Имитируем задержку сети (опционально)
  await new Promise(resolve => setTimeout(resolve, 500));
  return DEFAULT_YEARS;
}

export const getGroups = async (): Promise<Group[]> => {
  await new Promise(resolve => setTimeout(resolve, 500));
  return DEFAULT_GROUPS;
}


