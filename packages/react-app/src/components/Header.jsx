import { PageHeader } from "antd";
import React from "react";

// displays a page header

export default function Header() {
  return (
    <a href="/" /*target="_blank" rel="noopener noreferrer"*/>
      <PageHeader
        title="🏗 The Token Vendor"
        subTitle="Digital vending machine for buying and selling GOLD"
        style={{ cursor: "pointer" }}
      />
    </a>
  );
}
