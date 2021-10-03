import * as React from 'react';
import { Skeleton, SimpleGrid, Flex } from '@chakra-ui/react';

import { GraphQLTable } from '../GraphQLTable/GraphQLTable';

interface Row {
  key: number;
  cell: React.ReactNode;
}

interface Column {
  title: React.ReactNode;
  key: string;
  dataIndex: string;
}

export const TableLayoutSkeleton = ({ numberOfRows = 10, numberOfColumns = 3 }): JSX.Element => {
  let dataSource:Array<Row> = [];
  let columns:Array<Column> = [];

  for (var i = 0; i < numberOfColumns; i++) {
    columns.push(
      {
        title: <Skeleton />,
        key: `cell-${i}`,
        dataIndex: 'cell',
      }
    )
  }


  for (var i = 0; i < numberOfRows; i++) {
    dataSource.push(
      {
        key: i + 1,
        cell: <Skeleton height="30px" />,
      }
    )
  }

  return (
    <SimpleGrid columns={[1]}>
      <Flex direction="column">
        <GraphQLTable dataSource={dataSource} columns={columns} />
      </Flex>
    </SimpleGrid>
  )
}
