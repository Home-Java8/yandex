package com.dataformat.common.types;

import java.util.Arrays;

/**
 * @author Aleksandr Konstantinovitch
 * @version 2.0
 * @date 31/07/2014
 * {@link http://ru.wikipedia.org/wiki/Bencode}
 */

@SuppressWarnings("UnusedDeclaration")
public class User {
    public enum Gender { MALE, FEMALE }

    public static class Name {
        private String first, last;

        public String getFirst() { return first; }
        public String getLast() { return last; }

        public void setFirst(String s) { first = s; }
        public void setLast(String s) { last = s; }
    }

    private Gender gender;
    private Name name;
    private boolean isVerified;
    private byte[] userImage;

    public Name getName() { return name; }
    public boolean isVerified() { return isVerified; }
    public Gender getGender() { return gender; }
    public byte[] getUserImage() { return userImage; }

    public void setName(Name n) { name = n; }
    public void setVerified(boolean b) { isVerified = b; }
    public void setGender(Gender g) { gender = g; }
    public void setUserImage(byte[] b) { userImage = b; }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof User)) return false;

        User user = (User) o;

        if (isVerified != user.isVerified) return false;
        if (gender != user.gender) return false;
        if (name != null ? !name.equals(user.name) : user.name != null) return false;
        if (!Arrays.equals(userImage, user.userImage)) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = gender != null ? gender.hashCode() : 0;
        result = 31 * result + (name != null ? name.hashCode() : 0);
        result = 31 * result + (isVerified ? 1 : 0);
        result = 31 * result + (userImage != null ? Arrays.hashCode(userImage) : 0);
        return result;
    }

    @Override
    public String toString() {
        return "User{" +
                "gender=" + gender +
                ", name=" + name +
                ", isVerified=" + isVerified +
                ", userImage=" + Arrays.toString(userImage) +
                '}';
    }
}