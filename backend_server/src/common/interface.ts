export interface IUser {
  id: number;
  user_id: string;
  name: string;
  email: string;
  password: string;
}

export type TCb = (err: NodeJS.ErrnoException | null) => void;
export type TCb1<T> = (err: NodeJS.ErrnoException | null, arg: T) => void;

export type TAllowedKeycloakOperation = "get" | "post" | "put" | "delete";

export interface IKeycloakUser {
  id: string;
  createdTimestamp: number;
  username: string;
  enabled: boolean;
  totp: boolean;
  emailVerified: boolean;
  firstName: string;
  lastName: string;
  email: string;
  notBefore: number;
  access: {
    manageGroupMembership: boolean;
    view: boolean;
    mapRoles: boolean;
    impersonate: boolean;
    manage: boolean;
  };
}
