import * as React from 'react';
import {
  Box,
  Flex,
  Heading,
  Spacer,
} from "@chakra-ui/react"

interface PageHeaderProps {
  title: React.ReactNode,
  extra?: React.ReactNode,
  className?: string;
  onBack?: (e?: React.MouseEvent<HTMLDivElement>) => void;
}

export const PageHeader: React.FunctionComponent<PageHeaderProps> = (props) => {
  const { title, extra, className } = props;
  return (
    <Flex className={className} p={4}>
      <Box>
        <Heading size="md">{title}</Heading>
      </Box>
      <Spacer />
      <Box>
        {extra}
      </Box>
    </Flex>
  )
}
